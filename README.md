## Introduction

This report delves into mock train ticket data for National Rail in the UK, spanning from January to April. The data comprises ticket types, journey details (including date, time, departure and arrival stations), ticket prices, and other attributes. The goal is to uncover insights that can guide operational decisions and customer service improvements.


## Problem Statement

* What are the most popular routes? 

* What are the peak travel times?

* How does revenue vary by ticket types and classes?

*What is the on-time performance? What are the main contributing factors?


## Data Cleaning and Transformation

To ensure robust analysis, the data underwent several cleaning and transformation processes:
* Empty entries in the 'Reason for Delay' column (27,481 instances) were replaced with the most frequent reason: 

* Weather Purchase time and date columns were formatted to the Date Time structure for consistency.

* A "Day Session" column was created to identify peak travel times during the day.

* "Day Name" column was extracted from the journey date to explore the busiest travel days.

* Weather-related entries were added to the 'Reason for Delay' column for clarity.


## Insights

Several compelling patterns emerged from the analysis:

1. Revenue Insights:
* Total revenue generated: £741,921 (from December 8, 2023, to April 30, 2024).

* Advance tickets contributed the most (£309,274), followed by Off-Peak (£223,338) and Anytime tickets (£209,309).

* Standard class generated £592,522, far outpacing First Class (£149,399).

2. Ticket Purchase Channels:
* Online purchases dominated, with 18,521 transactions compared to 13,132 offline purchases.

* Credit card was the most preferred payment method (19,136 transactions), followed by contactless payments (10,834).

3. Passenger Demographics:
  * A majority of passengers (20,918) were non-Railcard holders.

Adult Railcard users were the largest group among Railcard holders (4,846), followed by disabled and senior Railcard holders.

4. Ticket Class Distribution:
   * 90% of tickets sold were Standard Class (28,595), while First Class tickets accounted for only 3,058.


5. Travel Patterns:
  * Departure Stations: Manchester Piccadilly was the busiest departure point, with 5,650 journeys initiated.

  * Arrival Stations: Birmingham New Street was the top destination (7,742 arrivals).

  * Peak Times: Evening travel was highest (11,798 journeys), followed by mornings (10,984 journeys).

  *  Peak Days: Wednesday and Tuesday saw the most trips (4,692 and 4,607 respectively).


6. On-Time Performance:
   27,481 journeys were on time, while 2,292 were delayed and 1,880 canceled.

Weather conditions (927 delays) and technical issues (472 delays) were the main contributors.


## Recommendations

Based on the findings, several recommendations can be made:
* Focus on Standard Class: With over 90% of tickets sold in Standard Class, consider enhancing facilities and offerings to attract more passengers.

* Improve Online Ticketing: Since online sales dominate, investing further in digital ticketing platforms could streamline user experiences.

* Delay Mitigation Strategies: Address top delay factors by improving weather forecasting systems and reinforcing technical reliability.

* Optimize Evening Travel Services: Increase service frequency and enhance offerings during peak evening travel times.

## Conclusion
This analysis provides valuable insights into travel patterns, revenue distribution, passenger behavior, and operational performance for National Rail. By leveraging these findings, the company can optimize services, improve customer satisfaction, and increase profitability.
