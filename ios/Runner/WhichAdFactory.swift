import google_mobile_ads
import UIKit

class WhichAdFactory: NSObject, FLTNativeAdFactory {
    func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable: Any]?) -> GADNativeAdView? {
        // Create and place the ad in the view hierarchy.
        guard let adView = Bundle.main.loadNibNamed("WhichAdView", owner: nil, options: nil)?.first as? GADNativeAdView else {
            return nil
        }

        // Populate the native ad view with the native ad assets.
        // The headline is guaranteed to be present in every native ad.
        (adView.headlineView as? UILabel)?.text = nativeAd.headline

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        if let body = nativeAd.body {
            (adView.bodyView as? UILabel)?.text = body
            adView.bodyView?.isHidden = false
        } else {
            adView.bodyView?.isHidden = true
        }

        if let callToAction = nativeAd.callToAction {
            (adView.callToActionView as? UILabel)?.text = nativeAd.callToAction
            adView.callToActionView?.isHidden = false
        } else {
            adView.callToActionView?.isHidden = true
        }

        if let icon = nativeAd.icon {
            (adView.iconView as? UIImageView)?.image = icon.image
            adView.iconView?.isHidden = false
        } else {
            adView.iconView?.isHidden = true
        }

//        if let store = nativeAd.store {
//            (adView.storeView as? UILabel)?.text = store
//            adView.storeView?.isHidden = false
//        } else {
//            adView.storeView?.isHidden = true
//        }

//        if let price = nativeAd.price {
//            (adView.priceView as? UILabel)?.text = price
//            adView.priceView?.isHidden = false
//        } else {
//            adView.priceView?.isHidden = true
//        }

        if let advertiser = nativeAd.advertiser {
            (adView.advertiserView as? UILabel)?.text = advertiser
            adView.advertiserView?.isHidden = false
        } else {
            adView.advertiserView?.isHidden = true
        }

        // In order for the SDK to process touch events properly, user interaction
        // should be disabled.
        adView.callToActionView?.isUserInteractionEnabled = false

        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        adView.nativeAd = nativeAd

        return adView
    }
}

