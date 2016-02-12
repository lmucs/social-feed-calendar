package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;
import com.android.volley.Response;
import com.google.gson.Gson;
import org.json.JSONObject;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.activities.ManageFeeds;
import cs.lmu.grapevine.adapters.SocialMediaListAdapter;
import cs.lmu.grapevine.entities.SocialMediaFeed;

/**
 * Created by
 * jeff on 11/21/15.
 */
public class FollowFeedSuccessListener implements Response.Listener<JSONObject> {
    private Activity parentActivity;
    private SocialMediaFeed newFeed;

    @Override
    public void onResponse(JSONObject response) {
        stopProgressSpinner();
        addViewToList();
        toastSuccessMessage();
    }

    public FollowFeedSuccessListener(Activity parentActivity, String eventJsonString ) {
        this.parentActivity = parentActivity;
        Gson gson = new Gson();
        eventJsonString =  eventJsonString.replace("networkName", "network_name")
                                          .replace("feedName","feed_name");

        newFeed = gson.fromJson(eventJsonString,SocialMediaFeed.class);
    }

    public void stopProgressSpinner(){
        parentActivity.findViewById(R.id.follow_feed_progress).setVisibility(View.INVISIBLE);
    }

    public void toastSuccessMessage() {
        TextView feedName =  (TextView)parentActivity.findViewById(R.id.feed_name);
        RadioGroup socialMediaGroup = (RadioGroup) parentActivity.findViewById(R.id.social_media_options);
        int feedRadioButtonId = socialMediaGroup.getCheckedRadioButtonId();
        String sourceName = (String)((RadioButton)parentActivity.findViewById(feedRadioButtonId)).getText();

        int duration = Toast.LENGTH_SHORT;
        String successString =  " Now following "
                               + sourceName
                               + " feed "
                               + feedName.getText().toString().trim();

        Toast toast = Toast.makeText(parentActivity, successString, duration);
        toast.show();
    }

    public void addViewToList() {
        if (ManageFeeds.feedsAdapter.getCount() == 0) {
            clearNoFeedsMessage();
        }

        if (ManageFeeds.feedsAdapter == null) {
            SocialMediaListAdapter adapter = new SocialMediaListAdapter(parentActivity, ManageFeeds.feedsFollowed);
        }
        ManageFeeds.feedsAdapter.add(newFeed);

    }

    public void clearNoFeedsMessage() {
        TextView noFeedsMessage = (TextView)parentActivity.findViewById(R.id.no_feeds_message);
        noFeedsMessage.setText("");
    }
}
