package cs.lmu.grapevine.requests;

import android.app.Activity;
import com.android.volley.toolbox.JsonArrayRequest;
import java.util.HashMap;
import java.util.Map;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.UserProfile;
import cs.lmu.grapevine.requests.listeners.error.EventErrorListener;
import cs.lmu.grapevine.requests.listeners.success.EventSuccessListener;

/**
 * A request to get events for a user's event feed.
 */
public class EventFeedRequest extends JsonArrayRequest {
    private Activity parentActivity;

    public EventFeedRequest(Activity parentActivity) {
        super(Method.GET,
                BuildConfig.API_HOST
                + "users/"
                + UserProfile.getUserId(parentActivity)
                + "/events",
              null,
              new EventSuccessListener(parentActivity),
              new EventErrorListener(parentActivity)
        );
        this.parentActivity = parentActivity;
    }

    @Override
    public Map<String, String> getHeaders(){
        HashMap<String, String> eventRequestHeaders = new HashMap<>();
        eventRequestHeaders.put("x-access-token", UserProfile.getAuthenticationToken(parentActivity));
        eventRequestHeaders.put("Content-Type", "application/json");

        return eventRequestHeaders;
    }
}