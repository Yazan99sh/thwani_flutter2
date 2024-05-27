package ae.altkamul.thawani_flutter

import ae.altkamul.thawani_flutter.make_payment.Middleware
import ae.altkamul.thawani_flutter.make_payment.controller.ThwaniPaymentView
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ThawaniFlutterPlugin */
class ThawaniFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  var context: Context? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    Middleware.channel = MethodChannel(flutterPluginBinding.binaryMessenger, "thawani_flutter")
    Middleware.channel!!.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method.equals("makePayment")) {
      // Get the payment details from the call arguments
      val arguments: HashMap<String, Any>? = call.argument("paymentDetails")
      // Convert the HashMap to a model class
      val intent = Intent(context, ThwaniPaymentView::class.java)
      intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_MULTIPLE_TASK
      // Pass payment details to the PaymentActivity if needed
      intent.putExtra("paymentDetails", arguments)
      // Start the activity
      context?.startActivity(intent)
      result.success("Payment initiated");
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    Middleware.channel?.setMethodCallHandler(null)
  }
}
