package cs.lmu.grapevine.requests.listeners;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;
import com.android.volley.Response;
import org.json.JSONException;
import org.json.JSONObject;
import cs.lmu.grapevine.FeedEvents;
import cs.lmu.grapevine.MainActivity;
import cs.lmu.grapevine.R;

/**
 * Created by jeff on 10/18/15.
 */
public class RegisterUserSuccessListener implements Response.Listener<JSONObject> {
    private Activity parentActivity;

    public RegisterUserSuccessListener(Activity parentActivity) {
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

        toastSuccessMessage();
    }

    public void toastSuccessMessage() {
        Context context = parentActivity.getApplicationContext();
        int duration = Toast.LENGTH_SHORT;

        Toast toast = Toast.makeText(context, R.string.register_user_success, duration);
        toast.show();
    }
}
