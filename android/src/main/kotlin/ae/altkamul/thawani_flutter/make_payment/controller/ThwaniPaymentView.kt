package ae.altkamul.thawani_flutter.make_payment.controller;

import ae.altkamul.thawani_flutter.make_payment.Middleware
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.Window;

import java.util.HashMap;

import ae.altkamul.thawani_flutter.make_payment.models.*;
import ae.altkamul.thawani_flutter.make_payment.models.PosConfiguration;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import om.thawani.lamsa.sdk.LamsaSDK
import om.thawani.lamsa.sdk.enums.PaymentOptions
import om.thawani.lamsa.sdk.models.InitOptionsModel
import om.thawani.lamsa.sdk.models.PaymentResultModel

//import okhttp3.HttpUrl;
//import okhttp3.MediaType;
//import okhttp3.OkHttpClient;
//import okhttp3.Request;
//import okhttp3.RequestBody;
//import okhttp3.Response;

class ThwaniPaymentView : Activity() {

    companion object {
        const val LAMSA_REQUEST_CODE = 1000
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        initViews()
    }

    private fun initViews() {
        val intent = intent ?: return
        val extraString = intent.getSerializableExtra("paymentDetails") as? HashMap<String, Any>
        extraString?.let {
            val configuration = PosConfiguration.convertHashMapToModel(it)
            processCPOCSale(configuration)
        }
    }

    private fun processCPOCSale(posConfiguration: PosConfiguration) {
        val amount = posConfiguration.amount
        if (amount.toDouble() <= 0.0) {
            finish()
            return
        }
        val intent = Intent(this, LamsaSDK::class.java)
        val args = InitOptionsModel(
            amount = posConfiguration.amount.toDouble(),
            authKey = posConfiguration.authKey,
            remarks = posConfiguration.remark,
            isProduction = posConfiguration.production,
            paymentOption = posConfiguration.option,
            autoCloseInMillis = posConfiguration.timeOut //Optional, auto close after 3 second
        )
        intent.putExtra("SDKInitOptions", args)
        startActivityForResult(intent, LAMSA_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val arguments = HashMap<String, Any>()
        if (requestCode == LAMSA_REQUEST_CODE) {
            // If payment success
            if (resultCode == RESULT_OK) {
                val result = data?.getSerializableExtra("result") as? PaymentResultModel
                if (result != null) {
                    arguments["status"] = result.success ?: true
                    arguments["message"] = result.description ?: ""
                    arguments["paymentId"] = result.paymentId ?: ""
                    arguments["invoice"] = result.invoice ?: ""
                    arguments["paymentStatus"] = result.paymentStatus ?: -1
                } else {
                    // Handle unexpected error
                    arguments["status"] = false
                    arguments["message"] = "unexpected error happened"
                }
            }

            // If payment cancelled or failed
            if (resultCode == RESULT_CANCELED) {
                val result =
                    data?.getSerializableExtra("result") as? PaymentResultModel
                if (result != null) {
                    // Convert JsonString to what you required
                    arguments["status"] = result.success ?: true
                } else {
                    arguments["status"] = false
                    arguments["message"] = "unexpected error happened"
                }
            }
            val handler = Handler(Looper.getMainLooper())
            Log.i("Posting", "Posting to flutter channel")
            handler.post({
                Middleware.channel?.invokeMethod(
                    "makePayment",
                    arguments,
                    object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            Log.i("fromInvoke", "success: $result")
                        }

                        override fun error(
                            errorCode: String,
                            errorMessage: String?,
                            errorDetails: Any?
                        ) {
                            Log.i("fromInvoke", "failed: $errorMessage")
                        }

                        override fun notImplemented() {
                            Log.i("fromInvoke", "not implemented")
                        }
                    }
                )
                finish()
            })
        }
    }
}


//    private fun sendNotification(status: Boolean) {
//        val client = OkHttpClient()
//        val mediaType = MediaType.parse("application/json")
//        val apiKey = "fa517eb74a8655244dc563c201b2ea2a822ce5a4559
//    }