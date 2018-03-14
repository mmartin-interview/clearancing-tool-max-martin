# Stitch Fix Clearance Tool

## Business Problem

We need to clearance inventory from time to time.  Certain items don't sell through to our clients, so every month, we collect certain unsold items and sell them to a third party vendor for a portion of their wholesale price. This application facilitates that process.

## Your Assignment

An early-career developer on our team was tasked with refactoring the code for clearance batches. The team has been moving to [service objects](https://multithreaded.stitchfix.com/blog/2015/06/02/anatomy-of-service-objects-in-rails/) and this application doesn't currently work that way, so her work this sprint was to bring the app in line with the team's current approach to services. Note that we value consistent code and follow the [GitHub Ruby style guide](https://github.com/github/rubocop-github/blob/master/STYLEGUIDE.md).

It's almost the end of the sprint, and she is done with her refactor now. She opened a pull request and selected you to review her code. Click on the 'Pull Requests' tab for the GitHub project and look for the PR called "Refactor to use a service". This is what you will be reviewing.

Please approach this project as you would a work assignment. The feedback you leave on her pull request should be intended for a real developer who has tried her best to meet the requirements for this work.

We take a conversational approach to code reviews at Stitch Fix, so your goal in this should be to start a conversation. Feel free to ask questions of the person whose code you are reviewing and leave thoughtful feedback.

If you are not familiar with the way that pull request reviews work, you can refer to [the documentation](https://help.github.com/articles/reviewing-changes-in-pull-requests/) on GitHub.com.

## Vocabulary

_Items_ refer to individual pieces of clothing.  So, if we have two of the exact same type of jeans, we have two items.  Items are grouped by _style_, so
the two aforementioned items would have the same style.

Important data about an item is:

* size
* color
* status - sellable, not sellable, sold, clearanced
* price sold
* date sold

A style's important data is:

* wholesale price
* retail price
* type - pants, shirts, dresses, skirts, other
* name

The _users_ of this application are warehouse employees (not developers).  They have a solid understanding the business process they must carry out and look to our software to support them.

## About the App

This application currently handles the clearance task in a very basic way. A spreadsheet containing a list of item ids is uploaded and those items are clearanced as a batch. Items can only be sold at clearance if their status is 'sellable'. When the item is clearanced, we sell it at 75% of the wholesale price, and record that as "price sold".

You should be able to play around with the app by uploading the CSV file in this repository.

## Set Up

Follow these steps if you want to run the app locally:

- `bundle install`
- `rake db:create`
- `rake db:migrate`
- `rake db:seed`
- `rails s`

Then you can access the app at http://localhost:3000/

## Tech Specs:

- Rails 5.1
- Ruby 2.4.2
- SQLite
