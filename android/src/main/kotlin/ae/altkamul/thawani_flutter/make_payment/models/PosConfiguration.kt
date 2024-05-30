package ae.altkamul.thawani_flutter.make_payment.models
import om.thawani.lamsa.sdk.LamsaSDK
import om.thawani.lamsa.sdk.enums.PaymentOptions
import java.util.HashMap

data class PosConfiguration(
    val authKey: String = "none",
    val remark: String? = null,
    val production: Boolean = false,
    val option: PaymentOptions = PaymentOptions.CARD_ACCEPT,
    val amount: Number = 0.0,
    val timeOut: Int = 0
) {

    companion object {
        fun convertHashMapToModel(hashMap: HashMap<String, Any>): PosConfiguration {
            return PosConfiguration(
                hashMap["authKey"] as String,
                hashMap["remark"] as? String,
                hashMap["production"] as? Boolean ?: false,
                getEnumValue(hashMap["option"] as? String ?: "card_accept"),
                hashMap["amount"] as? Number ?: 0.0,
                hashMap["timeout"] as? Int ?: 0
            )
        }
        private fun getEnumValue(enumName: String): PaymentOptions {
            return when (enumName) {
                "card_accept" -> PaymentOptions.CARD_ACCEPT
                else -> PaymentOptions.CARD_REJECT
            }
        }
    }
}