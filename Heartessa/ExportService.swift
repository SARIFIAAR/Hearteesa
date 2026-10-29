import SwiftUI
import PDFKit
import Charts

@MainActor
enum ExportService {

    // MARK: - CSV

    static func csvData(readings: [BPReading]) -> Data {
        var lines = ["Date,Systolic,Diastolic,Pulse,Category,Arm,Position,Notes"]
        let fmt = ISO8601DateFormatter()
        for r in readings.sorted(by: { $0.timestamp > $1.timestamp }) {
            let row = [
                fmt.string(from: r.timestamp),
                "\(r.systolic)",
                "\(r.diastolic)",
                "\(r.pulse)",
                r.category.rawValue,
                r.arm.rawValue,
                r.position.rawValue,
                r.notes.replacingOccurrences(of: ",", with: ";")
                       .replacingOccurrences(of: "\n", with: " ")
            ].joined(separator: ",")
            lines.append(row)
        }
        let utf8BOM: [UInt8] = [0xEF, 0xBB, 0xBF]
        let body = lines.joined(separator: "\n").data(using: .utf8) ?? Data()
        return Data(utf8BOM) + body
    }

    // MARK: - PDF

    static func pdfData(readings: [BPReading]) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        return renderer.pdfData { ctx in
            ctx.beginPage()

            var y: CGFloat = 48

            // Header
            y = drawHeader(pageRect: pageRect, readings: readings, startY: y)
            y += 16

            // Chart
            y = drawChart(readings: readings, pageRect: pageRect, startY: y, ctx: ctx)
            y += 20

            // Stats
            y = drawStats(readings: readings, startY: y, pageRect: pageRect)
            y += 20

            // Table header
            y = drawTableHeader(startY: y, pageRect: pageRect)

            // Rows (paginate if needed)
            let sorted = readings.sorted { $0.timestamp > $1.timestamp }
            for reading in sorted {
                if y > pageRect.height - 80 {
                    ctx.beginPage()
                    y = 48
                    y = drawTableHeader(startY: y, pageRect: pageRect)
                }
                y = drawTableRow(reading: reading, startY: y, pageRect: pageRect)
            }

            // Footer
            drawFooter(pageRect: pageRect)
        }
    }

    // MARK: - Private drawing helpers

    @discardableResult
    private static func drawHeader(pageRect: CGRect, readings: [BPReading], startY: CGFloat) -> CGFloat {
        let title = "Heartessa — Blood Pressure Report"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor(red: 0.18, green: 0.62, blue: 0.43, alpha: 1)
        ]
        let titleSize = (title as NSString).size(withAttributes: attrs)
        (title as NSString).draw(at: CGPoint(x: 40, y: startY), withAttributes: attrs)

        if let earliest = readings.map(\.timestamp).min(),
           let latest   = readings.map(\.timestamp).max() {
            let range = "\(earliest.formatted(date: .abbreviated, time: .omitted)) – \(latest.formatted(date: .abbreviated, time: .omitted))"
            let subAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.secondaryLabel
            ]
            (range as NSString).draw(
                at: CGPoint(x: 40, y: startY + titleSize.height + 4), withAttributes: subAttrs)
        }

        let countAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let countStr = "\(readings.count) readings"
        let countSize = (countStr as NSString).size(withAttributes: countAttrs)
        (countStr as NSString).draw(
            at: CGPoint(x: pageRect.width - 40 - countSize.width, y: startY),
            withAttributes: countAttrs)

        return startY + titleSize.height + 20
    }

    @discardableResult
    private static func drawChart(readings: [BPReading], pageRect: CGRect,
                                   startY: CGFloat, ctx: UIGraphicsPDFRendererContext) -> CGFloat {
        guard !readings.isEmpty else { return startY }
        let chartHeight: CGFloat = 160
        let chartWidth: CGFloat = pageRect.width - 80
        let chartRect = CGRect(x: 40, y: startY, width: chartWidth, height: chartHeight)

        // Background
        UIColor.systemGray6.setFill()
        UIBezierPath(roundedRect: chartRect, cornerRadius: 8).fill()

        // Simple polyline for sys + dia
        let sorted = readings.sorted { $0.timestamp < $1.timestamp }
        guard sorted.count >= 2 else { return startY + chartHeight }

        let sysValues = sorted.map { CGFloat($0.systolic) }
        let diaValues = sorted.map { CGFloat($0.diastolic) }
        let allValues = sysValues + diaValues
        let minV = allValues.min()! - 10
        let maxV = allValues.max()! + 10

        func xPos(_ i: Int) -> CGFloat {
            chartRect.minX + 20 + CGFloat(i) / CGFloat(sorted.count - 1) * (chartWidth - 40)
        }
        func yPos(_ v: CGFloat) -> CGFloat {
            chartRect.maxY - 10 - (v - minV) / (maxV - minV) * (chartHeight - 20)
        }

        func drawLine(values: [CGFloat], color: UIColor) {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos(0), y: yPos(values[0])))
            for i in 1..<values.count {
                path.addLine(to: CGPoint(x: xPos(i), y: yPos(values[i])))
            }
            color.setStroke()
            path.lineWidth = 1.5
            path.stroke()
        }

        drawLine(values: sysValues, color: .systemRed)
        drawLine(values: diaValues, color: .systemBlue)

        // Legend
        let legY = startY + chartHeight + 6
        UIColor.systemRed.setFill()
        UIBezierPath(rect: CGRect(x: 40, y: legY + 4, width: 12, height: 3)).fill()
        let sysLabel = "Systolic"
        (sysLabel as NSString).draw(at: CGPoint(x: 56, y: legY),
            withAttributes: [.font: UIFont.systemFont(ofSize: 9), .foregroundColor: UIColor.secondaryLabel])

        UIColor.systemBlue.setFill()
        UIBezierPath(rect: CGRect(x: 100, y: legY + 4, width: 12, height: 3)).fill()
        let diaLabel = "Diastolic"
        (diaLabel as NSString).draw(at: CGPoint(x: 116, y: legY),
            withAttributes: [.font: UIFont.systemFont(ofSize: 9), .foregroundColor: UIColor.secondaryLabel])

        return legY + 16
    }

    @discardableResult
    private static func drawStats(readings: [BPReading], startY: CGFloat, pageRect: CGRect) -> CGFloat {
        guard !readings.isEmpty else { return startY }
        let avgSys = readings.map(\.systolic).reduce(0, +) / readings.count
        let avgDia = readings.map(\.diastolic).reduce(0, +) / readings.count
        let minSys = readings.map(\.systolic).min()!
        let maxSys = readings.map(\.systolic).max()!

        let stats = "Average: \(avgSys)/\(avgDia) mmHg   |   Systolic range: \(minSys)–\(maxSys) mmHg   |   Readings: \(readings.count)"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.label
        ]
        (stats as NSString).draw(at: CGPoint(x: 40, y: startY), withAttributes: attrs)
        return startY + 20
    }

    @discardableResult
    private static func drawTableHeader(startY: CGFloat, pageRect: CGRect) -> CGFloat {
        let cols: [(String, CGFloat)] = [
            ("Date & Time", 40), ("Sys/Dia", 175), ("Pulse", 230),
            ("Category", 270), ("Arm", 370), ("Position", 410)
        ]
        let hAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9, weight: .semibold),
            .foregroundColor: UIColor.secondaryLabel
        ]
        UIColor.systemGray5.setFill()
        UIBezierPath(rect: CGRect(x: 40, y: startY, width: pageRect.width - 80, height: 18)).fill()
        for (label, x) in cols {
            (label as NSString).draw(at: CGPoint(x: x, y: startY + 4), withAttributes: hAttrs)
        }
        return startY + 22
    }

    @discardableResult
    private static func drawTableRow(reading: BPReading, startY: CGFloat, pageRect: CGRect) -> CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor.label
        ]
        let dateStr = reading.timestamp.formatted(.dateTime.month(.twoDigits).day(.twoDigits)
            .year(.twoDigits).hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits))
        let data: [(String, CGFloat)] = [
            (dateStr, 40),
            ("\(reading.systolic)/\(reading.diastolic)", 175),
            ("\(reading.pulse)", 230),
            (reading.category.rawValue, 270),
            (reading.arm.rawValue, 370),
            (reading.position.rawValue, 410)
        ]
        for (text, x) in data {
            (text as NSString).draw(at: CGPoint(x: x, y: startY + 3), withAttributes: attrs)
        }
        UIColor.systemGray5.setStroke()
        let sep = UIBezierPath()
        sep.move(to: CGPoint(x: 40, y: startY + 17))
        sep.addLine(to: CGPoint(x: pageRect.width - 40, y: startY + 17))
        sep.lineWidth = 0.5
        sep.stroke()
        return startY + 20
    }

    private static func drawFooter(pageRect: CGRect) {
        let footer = "Generated by Heartessa  ·  Not a medical device  ·  \(Date().formatted(date: .abbreviated, time: .shortened))"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: UIColor.tertiaryLabel
        ]
        let size = (footer as NSString).size(withAttributes: attrs)
        (footer as NSString).draw(
            at: CGPoint(x: (pageRect.width - size.width) / 2, y: pageRect.height - 32),
            withAttributes: attrs)
    }
}
