package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.widget.TextView;
import android.widget.Toast;
import com.android.volley.Response;
import java.util.ArrayList;

import cs.lmu.grapevine.R;
import cs.lmu.grapevine.activities.ManageFeeds;
import cs.lmu.grapevine.entities.SocialMediaFeed;

/**
 * Created by jeff on 12/7/15.
 */
public class UnfollowFeedSuccessListener implements Response.Listener {
    private Activity parentActivity;
    private String   network;
    private String   feed;

    public UnfollowFeedSuccessListener(Activity parentActivity, String network, String feed) {
        this.parentActivity = parentActivity;
        this.network = network;
        this.feed = feed;
    }

    @Override
    public void onResponse(Object response) {
        toastSuccessMessage();
        removeFeedViewFromList();
    }

    private void toastSuccessMessage() {
        int duration = Toast.LENGTH_SHORT;
        String successString = "feed " + feed + " unfollowed";
        Toast toast = Toast.makeText(parentActivity, successString, duration);
        toast.show();
    }

    private void removeFeedViewFromList() {
        ArrayList feedsStillFollowed = new ArrayList();
        for (SocialMediaFeed feed: ManageFeeds.feedsFollowed) {
            if (!(feed.getName().equals(this.feed) && feed.getNetworkName().equals(network))) {
                feedsStillFollowed.add(feed);
            }
        }

        ManageFeeds.feedsFollowed.clear();
        ManageFeeds.feedsFollowed.addAll(feedsStillFollowed);
        ManageFeeds.feedsAdapter.notifyDataSetChanged();

        if (ManageFeeds.feedsAdapter.getCount() == 0) {
            TextView noFeedsMessage =  ((TextView) parentActivity.findViewById(R.id.no_feeds_message));
            noFeedsMessage.setText(R.string.no_feeds_message);
        }
    }
}