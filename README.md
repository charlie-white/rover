## Rover.com Lead Data Engineer Project

This project answers the questions posed at this [site.](https://docs.google.com/document/d/199MSV-YncKhL1nFH7NoKq795f2BUGdk4vDiicJJJS1Q/pub)

#### The questions and answers
1. How many unique users both authenticated and anonymous visited the homepage?

    **Answer:** 4141
1. Of authenticated users who visited the homepage, what percent
   go on to visit a search page in less than 30 minutes?

    **Answer:** 46
1. What is the average number of search pages that a user visits?

    **Answer:** 1.1697
1. Which UTM source is best at generating users who visit the homepage and then a search page?

    **Answer:**  9113d19048abb65bbff551b3417301d6
1. If we were testing two different versions of the homepage and trying to measure their
   impact on search rates, what further information would you need and how would you collect it?

    **Answer:**
    At a minimum I would need to have a "bucket" identifier that indicates which version the user home page the user
    was shown.  This would allow me to find results such as those above broken down to the bucket.

    As for how I would collect it, I would expect the web application to log the bucket in the clickstream data. This could be
    accomplished using an Integer (or big int) that would allow for multiple tests by using the int as a bitmask. Running multiple
    tests at once could create some sort of cross test behavior and it may be difficult to get an accurate read on test results.

    This would allow me to know which bucket the user was in, but would be pretty limited information.  Things like
    percentage of users in each group, browser type, mobile or desktop, geo data, gender, age range, user level (newbie, power user, etc.), referrer, and others
    are all important in actually determining the results of the test.  Many of these attributes are common in clickstream
    logging and/or can be determined in ETL.

    I personally am not that knowledgeable in the analytics and modeling to determine the results of the test.  I would
    likely rely on those people to help define what additional information they need to validate the results of the test.

#### Process of obtaining the answers
The answers to these questions were calculated by loading the provided clickstream data into a table in MySQL.
Although MySQL would probably not be the appropriate tool for data analysis of clickstream data in general, given
this small set of data, and the tools readily available to me, it was a valid choice.  In a real life situation
I would choose a database such as Redshift, or possibly use Hadoop to perform the analysis.

The sql script **rover.sql** contains the steps that I used to load and query the data.

