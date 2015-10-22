package cs.lmu.grapevine.requests.listeners;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import com.android.volley.Response;
import org.json.JSONException;
import org.json.JSONObject;
import cs.lmu.grapevine.FeedEvents;
import cs.lmu.grapevine.MainActivity;

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
            MainActivity.authenticationToken = response.getString("token");
            MainActivity.userId              = Integer.parseInt(response.getString("userID"));

            Intent feedEvents = new Intent(parentActivity.getApplicationContext(), FeedEvents.class);
            parentActivity.startActivity(feedEvents);
        }
        catch (JSONException e) {
            Log.d("exception", "The JSON received did not have a key for authentication token.");
        }
    }
}