import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var offering: Offering?
    @State private var isLoading = true
    @State private var isPurchasing = false
    @State private var errorMessage: String?
    @State private var isRestoring = false

    var onPurchased: (() -> Void)?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "applewatch")
                            .font(.system(size: 56))
                            .foregroundStyle(Color(hex: "#2D9D6E"))

                        Text("Heartessa Premium")
                            .font(.system(size: 28, weight: .bold, design: .rounded))

                        Text("Apple Watch + iCloud sync across all your devices")
                            .font(.body).foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 8)

                    // Feature list
                    VStack(alignment: .leading, spacing: 12) {
                        PremiumFeatureRow(icon: "applewatch", text: "Log & track BP from your wrist")
                        PremiumFeatureRow(icon: "icloud.fill", text: "Sync across iPhone & iPad")
                        PremiumFeatureRow(icon: "person.2.fill", text: "Unlimited family profiles")
                        PremiumFeatureRow(icon: "pill.fill", text: "Medication tracking")
                        PremiumFeatureRow(icon: "chart.bar.fill", text: "Advanced analytics & insights")
                    }
                    .padding(.horizontal, 4)

                    // Packages
                    if isLoading {
                        ProgressView().padding()
                    } else if let offering {
                        VStack(spacing: 12) {
                            if let annual = offering.annual {
                                PackageCard(package: annual,
                                            badge: "Best Value",
                                            isPurchasing: isPurchasing,
                                            onTap: { purchase(annual) })
                            }
                            if let monthly = offering.monthly {
                                PackageCard(package: monthly,
                                            badge: nil,
                                            isPurchasing: isPurchasing,
                                            onTap: { purchase(monthly) })
                            }
                        }
                    } else {
                        Text("Could not load pricing. Check your connection.")
                            .font(.caption).foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    if let error = errorMessage {
                        Text(error).font(.caption).foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }

                    // Restore
                    Button {
                        Task { await restore() }
                    } label: {
                        if isRestoring {
                            ProgressView().scaleEffect(0.8)
                        } else {
                            Text("Restore Purchases")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .disabled(isRestoring || isPurchasing)

                    Text("Billed via App Store. Cancel anytime in Settings.\nNo commitment.")
                        .font(.caption2).foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Not Now") { dismiss() }
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            }
        }
        .task { await loadOffering() }
    }

    private func loadOffering() async {
        isLoading = true
        do {
            let offerings = try await Purchases.shared.offerings()
            offering = offerings.current
        } catch {
            errorMessage = "Could not load offerings."
        }
        isLoading = false
    }

    private func purchase(_ package: Package) {
        guard !isPurchasing else { return }
        isPurchasing = true
        errorMessage = nil
        Task {
            do {
                let result = try await Purchases.shared.purchase(package: package)
                if result.customerInfo.entitlements["premium"]?.isActive == true {
                    onPurchased?()
                    dismiss()
                }
            } catch {
                errorMessage = (error as? ErrorCode)?.description ?? error.localizedDescription
            }
            isPurchasing = false
        }
    }

    private func restore() async {
        isRestoring = true
        errorMessage = nil
        do {
            let info = try await Purchases.shared.restorePurchases()
            if info.entitlements["premium"]?.isActive == true {
                onPurchased?()
                dismiss()
            } else {
                errorMessage = "No active subscription found."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isRestoring = false
    }
}

// MARK: - Supporting Views

struct PackageCard: View {
    let package: Package
    let badge: String?
    let isPurchasing: Bool
    let onTap: () -> Void

    private var priceString: String { package.storeProduct.localizedPriceString }
    private var periodString: String {
        switch package.packageType {
        case .monthly: return "/month"
        case .annual:  return "/year"
        default:       return ""
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(package.storeProduct.localizedTitle)
                            .font(.headline).foregroundStyle(.primary)
                        if let badge {
                            Text(badge)
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(Color(hex: "#2D9D6E"))
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                        }
                    }
                    if package.packageType == .annual {
                        let monthly = package.storeProduct.price / 12
                        Text("~\(monthly.formatted(.currency(code: package.storeProduct.currencyCode ?? "USD")))/month")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(priceString)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    Text(periodString).font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(badge != nil ? Color(hex: "#2D9D6E") : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .disabled(isPurchasing)
        .opacity(isPurchasing ? 0.6 : 1)
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body).foregroundStyle(Color(hex: "#2D9D6E"))
                .frame(width: 24)
            Text(text).font(.subheadline)
            Spacer()
        }
    }
}
