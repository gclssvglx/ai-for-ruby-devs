## Slide 0

This is a very quick introduction to Generative AI for Ruby devs.

There will be quite a bit of code - most is surprisingly simple and easy to understand.

In fact, most of it is simply calling an API.

There are gotcha's, a load of new things to learn and some new ways of writing code as well.

This is a large and growing area, so I can't hope to give you anything like a full or through introduction.

Please also remember that I'm a developer, not a data scientist. I'll keep to the code as much as possible and leave the complex, messy sciencey stuff to other - more capable - folks.

My aim is to cover the basics of writing a Generative AI based app in Ruby. It should give you a head start when exploring the subject further on your own, and - I hope - maybe a start point for your own app.



## Slide 1

As with all emerging technology - there's a lot of new terminology and concepts to wrap your brain around.

As you're probably aware, there is also a vast amount of hype around AI right now plus a lot of fear and numerous concerns over this technology.

I'll let you make your own mind up on these things. But I do hope that I can leave you slightly better informed.


### Generative AI

Many of you - I'm sure - know of, or have messed about with Machine Learning. So, what's the difference between Generative AI and Machine Learning?

It boils down to: Generative AIs focus on creating new content. Machine Learning on the other hand, focuses on how to improve the performance of tasks, without being explicitly programmed to do that.

Essentially, Generative AI can be considered a subset - or the application of Machine Learning - specifically related to new content generation.


### Large Language Model (LLM)

A Large Language Model is a type of machine learning model that uses deep learning techniques (neural networks modeled in a similar way to the structure of the human brain), and massively large data sets, to understand, summarize, generate, and predict new content.

They are trained using self-supervised and semi-supervised learning.

LLMs use various Natural Language Processing (NLP) techniques such as generating and classifying text, answering questions in a conversational manner, and translating or transforming text from one language to another.


### Vectors

Language modeling is the task of assigning a probability to a sequence of words in some text. Then, based on statistical analysis, it becomes possible to predict the word (or words) that are most likely to come next.

This is where vectors come in.

A vector is simply an array of floats which have been created by applying language modeling to some text.


### Embeddings

This leads us to embeddings. These measure the relatedness of text strings by measuring the distance between two vectors. Small distances suggest high relatedness and large distances suggest low relatedness.


## Slide 7

Why custom content?

Most - if not all - LLMs have been ‘trained’ on content available on the internet. GTP-3 for example - which is one of the models we'll be using - was trained on nearly 236 million English documents from 5 different datasets - all taken from various internet sources.

As we all know the internet is full of: bias, misinformation, and fake content. And that can creep into the models responses.

Another issue is known as "hallucinating" - quite simply if the LLM cannot find the answer to your question, it will literally make one up.



## Slide 8

So, what can we do about this?

Two things essentially:

- We can use an un-trained LLM and train it on the content we choose - this is very time-consuming and very costly

- We can use a pre-trained LLM and send it the content we want it to base the answer on - tell it to do exactly that - and give it our question. This isn't perfect either, but is simpler and cheaper than the first option.

Both approaches help solve these issues - to a greater or lesser degree. However, it's this second option that we'll be using.

And what is our custom content? Something you're all familiar with - The GDS Way.




We're using the "gpt-3.5-turbo" as our CHAT_MODEL throughout.


### Role: "user"

This refers to the entity that is interacting with the model. A 'user' in this context provides instructions or messages to the model, so can guide the conversation, ask questions, and make requests to the model. In other words, you can control the behavior and context of the conversation.


The 'role' can take one of three values: 'system', 'user' or the 'assistant'


### Temperature


Indicates the randomness and creativity of the responses. Basically, a number between 0 and 1.

So, a temperature of 0 means the responses will be very similar, almost deterministic, while a temperature of 1 means the responses can vary wildly.

We'll be using a temperature of 0.5.

Notice that we're streaming the response to make the conversation more 'natural'.



This is where all the action happens...

Notice the new and improved prompt, complete with what to answer with, if it can't find an answer in the content. An instruction as to how we want the question answered, the question and the context - more on that in a tick.

The key method in the class is 'create_context'. This gets the nearest known neighbours, based on an embedding created form the question, and returns the content of the first one - this is the context.

We could use a higher number of potentially related ContentItem's - more context - but again, we're using a FREE API key - which means we'll hit a token rate limit for every request.

Essentially, a token is a numerical representaion of words or characters. You get roughly 4 characters per token, or 3/4 of a word. So, 100 tokens is about 75 words.

And because we're asking the model to give us an answer based on the content we supply - we have to supply that content - which means tokens. So, the more context we send the more acurate the answer will be, but also the more expensive it will be in terms of tokens.
