package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import com.android.volley.Response;
import org.json.JSONException;
import org.json.JSONObject;
import cs.lmu.grapevine.activities.EventFeed;
import cs.lmu.grapevine.activities.Login;

/**
 * Listener for successful login requests.
 */
public class LoginSuccessListener implements Response.Listener<JSONObject> {
    private Activity parentActivity;

    public LoginSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onResponse(JSONObject response) {
        try{
            Login.authenticationToken = response.getString("token");
            Login.userId              = Integer.parseInt(response.getString("userID"));

            Intent feedEvents = new Intent(parentActivity.getApplicationContext(), EventFeed.class);
            parentActivity.startActivity(feedEvents);
        }
        catch (JSONException e) {
            Log.d("exception", "The JSON received did not have a key for authentication token.");
        }
    }
}