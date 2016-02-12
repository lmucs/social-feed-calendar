package cs.lmu.grapevine.entities;

import com.google.gson.annotations.SerializedName;

import org.apache.commons.lang3.time.DateUtils;
import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

/**
 * Represents a database Event entity.
 */
public class Event implements Serializable, Comparable<Event>  {
    public static final int END_TIME_UNKNOWN = 0;

    private String title;
    @SerializedName("event_id")
    private int eventId;
    @SerializedName("time_processed")
    private long timeProcessed;
    private HashMap<String,String> location;
    @SerializedName("start_time")
    private long startTimeTimestamp;
    @SerializedName("end_time")
    private long endTimeTimestamp;
    private String[] tags;
    private String url;
    @SerializedName("post")
    private String postContent;
    @SerializedName("feed_id")
    private long feedId;
    @SerializedName("processed_info")
    private String processedInfo;
    @SerializedName("is_all_day")
    private boolean isAllDay;
    @SerializedName("end_time_is_known")
    private boolean endTimeIsKnown;
    private String author;

    public boolean endTimeIsKnown() {
        return endTimeIsKnown;
    }

    public void setEndTimeIsKnown(boolean endTimeIsKnown) {
        this.endTimeIsKnown = endTimeIsKnown;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public boolean isAllDay() {
        return isAllDay;
    }

    public void setIsAllDay(boolean isAllDay) {
        this.isAllDay = isAllDay;
    }

    public String getProcessedInfo() {
        return processedInfo;
    }

    public void setProcessedInfo(String processedInfo) {
        this.processedInfo = processedInfo;
    }

    public String getPostContent() {
        return postContent;
    }

    public void setPostContent(String postContent) {
        this.postContent = postContent;
    }

    public long getFeedId() {
        return feedId;
    }

    public void setFeedId(long feedId) {
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

    public HashMap<String,String> getLocation() {
        return location;
    }

    public void setLocation(HashMap<String,String> location) {
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

    public boolean isMultiDay() {
        return !(getEndTimeTimestamp()==0) && !(DateUtils.isSameDay(getStartDate(), getEndDate()));
    }

    public boolean isToday() {
        Date today     = new Date(Calendar.getInstance().getTimeInMillis());
        return isOn(today);
    }

    public boolean isOn(Date date) {

        Date endDate   = new Date(endTimeTimestamp);
        Date startDate = new Date(startTimeTimestamp);

        return DateUtils.isSameDay(date, startDate)
                || (DateUtils.isSameDay(date, endDate))
                || (isMultiDay() && startDate.before(date) && endDate.after(date));
    }

    public boolean startsLaterToday() {
        Date today = new Date(Calendar.getInstance().getTimeInMillis());
        Date startDate = new Date(startTimeTimestamp);

        return DateUtils.isSameDay(today, startDate) && startDate.after(today);
    }

    public boolean endsLaterToday() {
        Date today = new Date(Calendar.getInstance().getTimeInMillis());
        Date endDate = new Date(endTimeTimestamp);

        return DateUtils.isSameDay(today,endDate) && endDate.after(today);
    }

    public boolean isFinished() {
        Date now = new Date(Calendar.getInstance().getTimeInMillis());
        return  (endTimeTimestamp == 0 && getStartDate().before(now))
             || (endTimeTimestamp != 0 && now.after(getEndDate()));
    }

    public boolean startsAndEndsSameDay() {
        boolean sameDay = true;

        if (endTimeTimestamp == 0) {
            sameDay = false;
        } else {
            sameDay = DateUtils.isSameDay(getStartDate(), getEndDate());
        }

        return sameDay;
    }

    public Date getStartDate() {
        return new Date(startTimeTimestamp);
    }

    public Date getEndDate() {
        return new Date(endTimeTimestamp);
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

    @Override
    public int compareTo(Event another) {
        if (another == null) {
            throw new IllegalArgumentException();
        }

        if (this.getStartTimeTimestamp() < another.getStartTimeTimestamp()){
            return -1;
        } else if (another.getStartTimeTimestamp() < this.getStartTimeTimestamp()) {
            return 1;
        } else {
            return 0;
        }
    }

    public String toString() {
        return Integer.toString(eventId);
    }
}
