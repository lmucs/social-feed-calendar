package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import com.android.volley.Response;
import org.json.JSONException;
import org.json.JSONObject;
import cs.lmu.grapevine.UserProfile;
import cs.lmu.grapevine.activities.EventFeed;

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
        saveUserInfo(response);
        launchEventFeed();
    }

    private void saveUserInfo(JSONObject response) {
        try{
            UserProfile.saveAuthenticationToken(response.getString("token"), parentActivity);
            UserProfile.saveUserId(Integer.parseInt(response.getString("userID")), parentActivity);
            UserProfile.saveFirstName(response.getString("firstName"), parentActivity);
            UserProfile.saveLastName(response.getString("lastName"), parentActivity);
            UserProfile.saveLoginStatus(parentActivity);
        }
        catch (JSONException e) {
            Log.d("exception", "There was an error parsing a field from json", e);
        }
    }

    private void launchEventFeed() {
        Intent feedEvents = new Intent(parentActivity.getApplicationContext(), EventFeed.class);
        parentActivity.startActivity(feedEvents);
    }
}