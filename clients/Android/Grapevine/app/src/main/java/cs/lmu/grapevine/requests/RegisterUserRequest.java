package cs.lmu.grapevine.requests;

import android.app.Activity;
import com.android.volley.toolbox.JsonObjectRequest;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.requests.listeners.error.RegisterUserErrorListener;
import cs.lmu.grapevine.requests.listeners.success.RegisterUserSuccessListener;

/**
 * Request made to register a new user.
 * */
public class RegisterUserRequest extends JsonObjectRequest {
    private static String registerUrl = BuildConfig.API_HOST + "register";

    public RegisterUserRequest(Activity parentActivity, String requestBodyString) {
        super(Method.POST,
              registerUrl,
              RequestHelper.serializeRequestBody(requestBodyString),
              new RegisterUserSuccessListener(parentActivity),
              new RegisterUserErrorListener(parentActivity)
        );
    }
}
