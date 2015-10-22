package cs.lmu.grapevine.requests;

import android.app.Activity;
import com.android.volley.toolbox.JsonObjectRequest;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.requests.listeners.LoginErrorListener;
import cs.lmu.grapevine.requests.listeners.LoginSuccessListener;

/**
 * Un-authenticated request for logging in to Grapevine.
 */
public class LoginRequest extends JsonObjectRequest {
    private static String loginUrl = BuildConfig.API_HOST + "login";

    public LoginRequest(Activity parentActivity, String requestBodyString) {
        super(Method.POST,
              loginUrl,
              RequestHelper.serializeRequestBody(requestBodyString),
              new LoginSuccessListener(parentActivity),
              new LoginErrorListener(parentActivity)
        );
    }

}