package com.which464.which

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class WhichAdFactory(private val layoutInflater: LayoutInflater) : NativeAdFactory {
    @SuppressLint("InflateParams")
    override fun createNativeAd(nativeAd: NativeAd, customOptions: Map<String, Any>): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.which_ad, null) as NativeAdView

//        val mediaView = adView.findViewById<MediaView>(R.id.ad_media)
        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = adView.findViewById<TextView>(R.id.ad_body)
        val callToActionView = adView.findViewById<TextView>(R.id.ad_call_to_action)
        val iconView = adView.findViewById<ImageView>(R.id.ad_app_icon)
//        val priceView = adView.findViewById<TextView>(R.id.ad_price)
//        val starRatingView = adView.findViewById<RatingBar>(R.id.ad_stars)
//        val storeView = adView.findViewById<TextView>(R.id.ad_store)
        val advertiserView = adView.findViewById<TextView>(R.id.ad_advertiser)

        (headlineView as TextView).text = nativeAd.headline
//        mediaView.mediaContent = nativeAd.mediaContent

        if (nativeAd.body == null) {
            bodyView.visibility = View.INVISIBLE
        } else {
            bodyView.visibility = View.VISIBLE
            (bodyView as TextView).text = nativeAd.body
        }

        if (nativeAd.callToAction == null) {
            callToActionView.visibility = View.INVISIBLE
        } else {
            callToActionView.visibility = View.VISIBLE
            (callToActionView as TextView).text = nativeAd.callToAction
        }

        if (nativeAd.icon == null) {
            iconView.visibility = View.GONE
        } else {
            (iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
            iconView.visibility = View.VISIBLE
        }

//        if (nativeAd.price == null) {
//            priceView.visibility = View.INVISIBLE
//        } else {
//            priceView.visibility = View.VISIBLE
//            (priceView as TextView).text = nativeAd.price
//        }

//        if (nativeAd.store == null) {
//            storeView.visibility = View.INVISIBLE
//        } else {
//            storeView.visibility = View.VISIBLE
//            (storeView as TextView).text = nativeAd.store
//        }

//        if (nativeAd.starRating == null) {
//            starRatingView.visibility = View.INVISIBLE
//        } else {
//            (starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
//            starRatingView.visibility = View.VISIBLE
//        }

        if (nativeAd.advertiser == null) {
            advertiserView.visibility = View.INVISIBLE
        } else {
            advertiserView.visibility = View.VISIBLE
            (advertiserView as TextView).text = nativeAd.advertiser
        }

//        adView.mediaView = mediaView
        adView.headlineView = headlineView
        adView.bodyView = bodyView
        adView.callToActionView = callToActionView
        adView.iconView = iconView
//        adView.priceView = priceView
//        adView.starRatingView = starRatingView
//        adView.storeView = storeView
        adView.advertiserView = advertiserView

        adView.setNativeAd(nativeAd)

        return adView
    }
}