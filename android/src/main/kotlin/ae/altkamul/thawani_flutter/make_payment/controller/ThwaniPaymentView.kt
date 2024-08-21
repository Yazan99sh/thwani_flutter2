package ae.altkamul.thawani_flutter.make_payment.controller;

import ae.altkamul.thawani_flutter.make_payment.Middleware
import ae.altkamul.thawani_flutter.make_payment.models.*
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Window
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import okhttp3.HttpUrl
import okhttp3.HttpUrl.Companion.toHttpUrlOrNull
import okhttp3.MediaType
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.Response
import om.thawani.lamsa.sdk.LamsaSDK
import om.thawani.lamsa.sdk.models.InitOptionsModel
import om.thawani.lamsa.sdk.models.PaymentResultModel
import org.json.JSONObject

//import okhttp3.HttpUrl;
//import okhttp3.MediaType;
//import okhttp3.OkHttpClient;
//import okhttp3.Request;
//import okhttp3.RequestBody;
//import okhttp3.Response;

interface ThawaniCallback {
    fun onPaymentFinish(data: HashMap<String, Any>?)
}

class ThwaniPaymentView : Activity() {
    var posConfiguration: PosConfiguration? = null

    companion object {
        const val LAMSA_REQUEST_CODE = 1000
        var callback: ThawaniCallback? = null
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
            posConfiguration = PosConfiguration.convertHashMapToModel(it)
            processCPOCSale()
        }
    }

    private fun processCPOCSale() {
        val amount = posConfiguration?.amount
        if (amount!!.toDouble() <= 0.0) {
            finish()
            return
        }
        val intent = Intent(this, LamsaSDK::class.java)
        val args = InitOptionsModel(
            amount = posConfiguration?.amount!!.toDouble(),
            authKey = posConfiguration?.authKey!!,
            remarks = posConfiguration?.remark!!,
            isProduction = posConfiguration?.production ?: false,
            paymentOption = posConfiguration?.option,
            autoCloseInMillis = posConfiguration?.timeOut //Optional, auto close after 3 second
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
            //Log.i("Payment Finished", "Payment Response Details: " + arguments.toString())
            Log.i("Posting", "Posting to flutter channel")
            finish()
            callback?.onPaymentFinish(arguments)
            val thread = Thread {
                try {
                    if (posConfiguration!!.sendNotification) {
                        sendNotification(
                            arguments["status"] as Boolean,
                            posConfiguration!!.notifcationToken,
                            posConfiguration!!.notifcationTopic ?: "",
                            arguments["invoice"].toString(),
                            arguments["message"].toString()
                        )
                    }
                    handler.post({
                        try {
                            Log.i("Posting", "Posting to flutter channel " + Middleware.channel)
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
                        } catch (e: Exception) {
                            Log.e("Exception", e.toString())
                        }
                    })
                } catch (e: java.lang.Exception) {
                    Log.e("ExeptionDetected ------------->", e.toString())
                    e.printStackTrace()
                }
            }
            Log.e("ThreadForNotificationStarted ------------->", "&&&&")
            handler.postDelayed({
                thread.start()
            }, 1500);
        }
    }
    fun sendNotification(
        status: Boolean,
        token: String,
        topic: String,
        reference: String?,
        message: String?
    ) {
        val client: OkHttpClient = OkHttpClient()
        val mediaType: MediaType = "application/json".toMediaTypeOrNull()!!
        val requestBody = JSONObject()
        val data = JSONObject()
        val notification = JSONObject()
        try {
            Log.e("PrepareRequest ------------->", "Start")
            data.put("message", "Payment Completed !")
            data.put("notificationType", 1)
            // Assuming 'status' is a variable holding some value
            data.put("paymentStatus", status)
            data.put("transacionsReference", reference)
            data.put("message", message)
            notification.put("title", "Payment Completed")
            notification.put("body", "new Transaction")
            notification.put("badge", 1)

            requestBody.put("to", "/topics/$topic")
            requestBody.put("data", data)
            requestBody.put("notification", notification)
            Log.e("PrepareRequest ------------->", "Success" + requestBody.toString());

        } catch (e: Exception) {
            Log.e("PrepareRequest ------------->", "Failed")
            e.printStackTrace()
        }
        Log.e("PrepareRequest ------------->", "Success")
        val urlBuilder: HttpUrl.Builder = "https://api.pushy.me/push".toHttpUrlOrNull()!!.newBuilder()
        Log.e("PrepareRequest ------------->", "key" + token)
        urlBuilder.addQueryParameter("api_key", token)
        val body: RequestBody = RequestBody.create(mediaType, requestBody.toString())
        val request: Request = Request.Builder()
            .url(urlBuilder.build().toString())
            .post(body)
            .addHeader("Content-Type", "application/json")
            .build()
        //Log.e("PrepareRequest ------------->", "Success" + request.toString());
        try {
            val response: Response = client.newCall(request).execute()
            System.out.println(response.body?.string())
            Log.e("NotificationsSended ------------->", "Success")
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e("SENDNOTIFICATIONISSUE", e.toString())
            Log.e("NotificationsSended ------------->", "Failed")
        }
    }
}


//    private fun sendNotification(status: Boolean) {
//        val client = OkHttpClient()
//        val mediaType = MediaType.parse("application/json")
//        val apiKey = "fa517eb74a8655244dc563c201b2ea2a822ce5a4559
//    }