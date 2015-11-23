package cs.lmu.grapevine.entities;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Represents a database Event entity.
 */
public class Event implements Serializable {
    private String title;
    @SerializedName("event_id")
    private int eventId;
    @SerializedName("time_processed")
    private long timeProcessed;
    private String location;
    @SerializedName("start_time")
    private long startTimeTimestamp;
    @SerializedName("end_time")
    private long endTimeTimestamp;
    private boolean repeatsWeekly;
    private String[] tags;
    private String url;
    @SerializedName("postcontent")
    private String postContent;
    @SerializedName("feed_id")
    private int feedId;

    public static int MILLISECONDS_PER_SECOND = 1000;

    public int getFeedId() {
        return feedId;
    }

    public void setFeedId(int feedId) {
        this.feedId = feedId;
    }

    public void setEndTimeTimestamp(long endTimeTimestamp) {
        this.endTimeTimestamp = endTimeTimestamp;
    }

    public void setStartTimeTimestamp(long startTimeTimestamp) {
        this.startTimeTimestamp = startTimeTimestamp;
    }

    public long getTimeProcessed() {
        return timeProcessed;
    }

    public void setTimeProcessed(long timeProcessed) {
        this.timeProcessed = timeProcessed;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    private Event(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public  void setTitle(String title) {
        this.title = title;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public long getStartTimeTimestamp() {
        return startTimeTimestamp;
    }

    public void setStartTimeTimestamp(int startTimeTimestamp) {
        this.startTimeTimestamp = startTimeTimestamp;
    }

    public long getEndTimeTimestamp() {
        return endTimeTimestamp;
    }

    public void setEndTimeTimestamp(int endTimeTimestamp) {
        this.endTimeTimestamp = endTimeTimestamp;
    }

    public boolean isRepeatsWeekly() {
        return repeatsWeekly;
    }

    public void setRepeatsWeekly(boolean repeatsWeekly) {
        this.repeatsWeekly = repeatsWeekly;
    }

    public String[] getTags() {
        return tags;
    }

    public void setTags(String[] tags) {
        this.tags = tags;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getPost() {
        return postContent;
    }

    public void setPost(String post) {
        this.postContent = post;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Event event = (Event) o;

        return eventId == event.eventId;
    }

    @Override
    public int hashCode() {
        return eventId;
    }
}
