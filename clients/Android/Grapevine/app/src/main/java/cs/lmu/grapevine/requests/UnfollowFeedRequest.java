package cs.lmu.grapevine.requests;

import android.app.Activity;
import com.android.volley.toolbox.StringRequest;
import java.util.HashMap;
import java.util.Map;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.UserProfile;
import cs.lmu.grapevine.requests.listeners.error.UnfollowFeedErrorListener;
import cs.lmu.grapevine.requests.listeners.success.UnfollowFeedSuccessListener;

/**
 * Created by jeff on 12/7/15.
 */
public class UnfollowFeedRequest extends StringRequest {
    private Activity parentActivity;

    public UnfollowFeedRequest(Activity parentActivity, String network, String feed) {

        super(Method.DELETE,
              BuildConfig.API_HOST
                + "users/"
                + UserProfile.getUserId(parentActivity)
                + "/feeds/"
                + network
                + "/"
                + feed,
              new UnfollowFeedSuccessListener(parentActivity, network,feed),
              new UnfollowFeedErrorListener(parentActivity)
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
