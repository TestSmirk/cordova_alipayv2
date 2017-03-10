package com.plugin;

import android.text.TextUtils;

import com.alipay.sdk.app.PayTask;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

public class Alipay extends CordovaPlugin {
    private JSONObject jsonObject = new JSONObject();

    @Override
    public boolean execute(String action, final CordovaArgs args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                PayTask alipay = new PayTask(cordova.getActivity());
                PayResult payResult = new PayResult(alipay.payV2(args.optJSONObject(0).optString("orderInfo"), true));
                try {
                    jsonObject.put("resultStatus", payResult.getResultStatus());
                    jsonObject.put("memo", payResult.getMemo());
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (TextUtils.equals(payResult.getResultStatus(), "9000")) {
                    callbackContext.success(jsonObject);
                } else {
                    callbackContext.error(jsonObject);
                }
            }
        });
        return true;
    }

    public class PayResult {
        private String resultStatus;
        private String result;
        private String memo;

        public PayResult(Map<String, String> rawResult) {
            if (rawResult == null) {
                return;
            }

            for (String key : rawResult.keySet()) {
                if (TextUtils.equals(key, "resultStatus")) {
                    resultStatus = rawResult.get(key);
                } else if (TextUtils.equals(key, "result")) {
                    result = rawResult.get(key);
                } else if (TextUtils.equals(key, "memo")) {
                    memo = rawResult.get(key);
                }
            }
        }

        @Override
        public String toString() {
            return "resultStatus={" + resultStatus + "};memo={" + memo
                    + "};result={" + result + "}";
        }

        /**
         * @return the resultStatus
         */
        public String getResultStatus() {
            return resultStatus;
        }

        /**
         * @return the memo
         */
        public String getMemo() {
            return memo;
        }

        /**
         * @return the result
         */
        public String getResult() {
            return result;
        }
    }

}
