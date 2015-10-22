package cs.lmu.grapevine.requests;

import android.util.Log;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Static helper methods for making requests.
 */
public class RequestHelper {

    public static JSONObject serializeRequestBody(String requestBodyJsonString) {
        JSONObject requestBody = null;
        try {
            requestBody = new JSONObject(requestBodyJsonString);
        }
        catch (JSONException e) {
            Log.d("exception", "JSON was not serialized correctly");
        }
        return requestBody;
    }
}
