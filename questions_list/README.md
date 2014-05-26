# Problem

We have a mailing list were there are two kind of users: people that makes questions, and people that answers them, and ocassionally make posts. These are the problems we have:
* We need to provide a quick response for questions
* Every question must be answered
* We want to avoid multiple different answers per question, so that we don't generate confusion. 
* We don't want to waste resources - if someone has a response, other people writing another one should stop
* People who write answers should work on just a question at a given moment. 
* We would like to avoid answers from people that doesn't belong to the answering partition
* People that answers questions have a hierarchy. We don't want to rely on it frequently, but ocassionally we would like to override answers from a lower lever hierarchy.
* Questions are threaded.
* And much more...


# First iteration

* Write the most simple implementation. It just need to notify answering partition about new questions, and answer them. No duplicates answers validation will be added yet.

# Second iteration

* Add filtering of duplicated answers

# Thirds iteration

* Abort pending answers if one has already arrived

# 4th iteration

* Add fault tolerance to crashed in the list or any answering process. 


 
