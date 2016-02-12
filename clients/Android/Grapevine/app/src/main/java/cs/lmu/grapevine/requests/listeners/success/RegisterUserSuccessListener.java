package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;
import com.android.volley.Response;
import org.json.JSONException;
import org.json.JSONObject;

import cs.lmu.grapevine.UserProfile;
import cs.lmu.grapevine.activities.EventFeed;
import cs.lmu.grapevine.activities.Login;
import cs.lmu.grapevine.R;

public class RegisterUserSuccessListener implements Response.Listener<JSONObject> {
    private Activity parentActivity;

    public RegisterUserSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onResponse(JSONObject response) {
        try{
            UserProfile.saveAuthenticationToken(response.getString("token"),parentActivity);
            UserProfile.saveUserId(Integer.parseInt(response.getString("userID")),parentActivity);

            toastSuccessMessage();
            Intent feedEvents = new Intent(parentActivity.getApplicationContext(), EventFeed.class);
            parentActivity.startActivity(feedEvents);
        }
        catch (JSONException e) {
            Log.d("exception", "The JSON received did not have a key for authentication token.");
        }
    }

    public void toastSuccessMessage() {
        Context context = parentActivity.getApplicationContext();
        int duration = Toast.LENGTH_SHORT;

        Toast toast = Toast.makeText(context, R.string.register_user_success, duration);
        toast.show();
    }
}
