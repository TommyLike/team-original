---
title: A Visual Guide to LLM Agents
source: https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents
author: Maarten Grootendorst
archived: 2026-07-05
type: technical-visual-guide
---

# A Visual Guide to LLM Agents

### Exploring the main components of Single- and Multi-Agents

[![Image 3: Maarten Grootendorst's avatar](https://substackcdn.com/image/fetch/$s_!xeIW!,w_36,h_36,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F074f5565-4619-4c18-9ca5-519f7291e5f5_1664x1664.jpeg)](https://substack.com/@maartengrootendorst)

[Maarten Grootendorst](https://substack.com/@maartengrootendorst)

Mar 17, 2025

597

23

71

Share

##### Translations _- [Korean](https://tulip-phalange-a1e.notion.site/LLM-Agents-1b9c32470be2800fa672e82689018fc4) - [Chinese](https://mp.weixin.qq.com/s/QFJyS0TUCv-TT39isRLu3w) - [Vietnamese](https://viblo.asia/p/huong-dan-truc-quan-ve-llm-agents-obA46EnlVKv) - [French](https://lbourdois.github.io/blog/LLM\_Agents/)_

LLM Agents are becoming widespread, seemingly taking over the “regular” conversational LLM we are familiar with. These incredible capabilities are not easily created and require many components working in tandem.

[![Image 4](https://substackcdn.com/image/fetch/$s_!A_Oy!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fc3177e12-432e-4e41-814f-6febf7a35f68_1360x972.png)](https://substackcdn.com/image/fetch/$s_!A_Oy!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fc3177e12-432e-4e41-814f-6febf7a35f68_1360x972.png)

With over 60 custom visuals in this post, you will explore the field of LLM Agents, their main components, and explore Multi-Agent frameworks.

Thank you for reading _Exploring Language Models_! Subscribe to receive new posts on _Gen AI_ and the book: **[Hands-On Large Language Models](https://github.com/HandsOnLLM/Hands-On-Large-Language-Models)**

Subscribe

_👈 click on the stack of lines on the left to see a **Table of Contents** (ToC)_

# What Are LLM Agents?

To understand what LLM Agents are, let us first explore the basic capabilities of an LLM. Traditionally, an LLM does nothing more than next-token prediction.

[![Image 5](https://substackcdn.com/image/fetch/$s_!56c5!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F495cca88-574b-4ace-b785-d6d6746e8f81_1500x504.png)](https://substackcdn.com/image/fetch/$s_!56c5!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F495cca88-574b-4ace-b785-d6d6746e8f81_1500x504.png)

By sampling many tokens in a row, we can mimic conversations and use the LLM to give more extensive answers to our queries.

[![Image 6](https://substackcdn.com/image/fetch/$s_!tRvE!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F6cc95dc7-b956-425c-a548-3f1f9f3f4fd1_1500x260.png)](https://substackcdn.com/image/fetch/$s_!tRvE!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F6cc95dc7-b956-425c-a548-3f1f9f3f4fd1_1500x260.png)

However, when we continue the “conversation”, any given LLM will showcase one of its main disadvantages. It does not remember conversations!

[![Image 7](https://substackcdn.com/image/fetch/$s_!DDi3!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F969ff525-cab0-419e-9d83-3d85c1acfbe9_1716x544.png)](https://substackcdn.com/image/fetch/$s_!DDi3!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F969ff525-cab0-419e-9d83-3d85c1acfbe9_1716x544.png)

There are many other tasks that LLMs often fail at, including basic math like multiplication and division:

[![Image 8](https://substackcdn.com/image/fetch/$s_!DIAs!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fff414a39-4acb-4762-b902-433e5c8aadf1_1592x464.png)](https://substackcdn.com/image/fetch/$s_!DIAs!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fff414a39-4acb-4762-b902-433e5c8aadf1_1592x464.png)

Does this mean LLMs are horrible? Definitely not! There is no need for LLMs to be capable of everything as we can compensate for their disadvantage through external tools, memory, and retrieval systems.

Through external systems, the capabilities of the LLM can be enhanced. Anthropic calls this “The Augmented LLM”.

[![Image 9](https://substackcdn.com/image/fetch/$s_!i0V3!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4d245ca0-e18a-4b40-91d6-9d7247f2b83f_1332x584.png)](https://substackcdn.com/image/fetch/$s_!i0V3!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4d245ca0-e18a-4b40-91d6-9d7247f2b83f_1332x584.png)

For instance, when faced with a math question, the LLM may decide to use the appropriate tool (a **calculator**).

[![Image 10](https://substackcdn.com/image/fetch/$s_!owAU!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F56ec0862-cffb-45cc-a8d3-aa0581719d2d_1592x464.png)](https://substackcdn.com/image/fetch/$s_!owAU!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F56ec0862-cffb-45cc-a8d3-aa0581719d2d_1592x464.png)

So is this “Augmented LLM” then an Agent? No, and maybe a bit yes…

Let’s start with a definition of Agents:[1](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-1)

An **agent** is anything that can be viewed as perceiving its environment through **sensors** and acting upon that environment through **actuators**.

— Russell & Norvig, AI: A Modern Approach (2016)

Agents interact with their environment and typically consist of several important components:

*   **Environments** — The world the agent interacts with

*   **Sensors** — Used to observe the environment

*   **Actuators** — Tools used to interact with the environment

*   **Effectors**— The “brain” or rules deciding how to go from observations to actions

[![Image 11](https://substackcdn.com/image/fetch/$s_!Fi2z!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5f575b4a-783e-4ca5-be3f-c9ef7086b0da_1180x608.png)](https://substackcdn.com/image/fetch/$s_!Fi2z!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5f575b4a-783e-4ca5-be3f-c9ef7086b0da_1180x608.png)

This framework is used for all kinds of agents that interact with all kinds of environments, like robots interacting with their physical environment or AI agents interacting with software.

We can generalize this framework a bit to make it suitable for the “Augmented LLM” instead.

[![Image 12](https://substackcdn.com/image/fetch/$s_!4Db3!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe5cdee7c-ac55-4185-95fb-d88cc6395bf0_1180x608.png)](https://substackcdn.com/image/fetch/$s_!4Db3!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe5cdee7c-ac55-4185-95fb-d88cc6395bf0_1180x608.png)

Using the “Augmented” LLM, the Agent can observe the environment through textual input (as LLMs are generally **textual models**) and perform certain actions through its use of tools (like **searching the web**).

To select which actions to take, the LLM Agent has a vital component: its ability to plan. For this, LLMs need to be able to “reason” and “think” through methods like chain-of-thought.

[![Image 13](https://substackcdn.com/image/fetch/$s_!PLV6!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F7cc4d8b1-bb2b-45f1-a17e-a53357d3d999_1228x1004.png)](https://substackcdn.com/image/fetch/$s_!PLV6!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F7cc4d8b1-bb2b-45f1-a17e-a53357d3d999_1228x1004.png)

For more information about reasoning, check out **[The Visual Guide to Reasoning LLMs](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms)**

Using this reasoning behavior, LLM Agents will plan out the necessary actions to take.

[![Image 14](https://substackcdn.com/image/fetch/$s_!T9Eq!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8bebdfdf-74f8-4a3b-a54f-b7d643e97f63_1156x588.png)](https://substackcdn.com/image/fetch/$s_!T9Eq!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8bebdfdf-74f8-4a3b-a54f-b7d643e97f63_1156x588.png)

This planning behavior allows the Agent to understand the situation (**LLM**), plan next steps (**planning**), take actions (**tools**), and keep track of the taken actions (**memory**).

[![Image 15](https://substackcdn.com/image/fetch/$s_!rBUX!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fcece7ade-43c2-497a-8e78-e61cfcf467ac_1032x720.png)](https://substackcdn.com/image/fetch/$s_!rBUX!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fcece7ade-43c2-497a-8e78-e61cfcf467ac_1032x720.png)

Depending on the system, you can LLM Agents with varying degrees of autonomy.

[![Image 16](https://substackcdn.com/image/fetch/$s_!qWHu!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F98d5ce2c-e9ba-4f67-bc11-e62983f890a1_1736x1140.png)](https://substackcdn.com/image/fetch/$s_!qWHu!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F98d5ce2c-e9ba-4f67-bc11-e62983f890a1_1736x1140.png)

Depending on who you ask, a system is more “agentic” the more the LLM decides how the system can behave.

In the next sections, we will go through various methods of autonomous behavior through the LLM Agent’s three main components: **Memory**, **Tools**, and **Planning**.

# Memory

LLMs are forgetful systems, or more accurately, do not perform any memorization at all when interacting with them.

For instance, when you ask an LLM a question and then follow it up with another question, it will not remember the former.

[![Image 17](https://substackcdn.com/image/fetch/$s_!U2e0!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F7c6d3e7a-5cc0-440e-a3d6-3ddee9cd73f0_1032x568.png)](https://substackcdn.com/image/fetch/$s_!U2e0!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F7c6d3e7a-5cc0-440e-a3d6-3ddee9cd73f0_1032x568.png)

We typically refer to this as **short-term memory**, also called working memory, which functions as a buffer for the (near-) immediate context. This includes recent actions the LLM Agent has taken.

However, the LLM Agent also needs to keep track of potentially dozens of steps, not only the most recent actions.

[![Image 18](https://substackcdn.com/image/fetch/$s_!4Pkh!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fd93050da-f962-426c-87bc-9742b896e008_1320x888.png)](https://substackcdn.com/image/fetch/$s_!4Pkh!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fd93050da-f962-426c-87bc-9742b896e008_1320x888.png)

This is referred to as **long-term memory** as the LLM Agent could theoretically take dozens or even hundreds of steps that need to be memorized.

[![Image 19](https://substackcdn.com/image/fetch/$s_!XecI!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F81dfc42c-2cbd-4a1d-9430-4ac2518d4490_936x696.png)](https://substackcdn.com/image/fetch/$s_!XecI!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F81dfc42c-2cbd-4a1d-9430-4ac2518d4490_936x696.png)

Let’s explore several tricks for giving these models memory.

## Short-Term Memory

The most straightforward method for enabling short-term memory is to use the model's context window, which is essentially the number of tokens an LLM can process.

[![Image 20](https://substackcdn.com/image/fetch/$s_!JVFu!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F3512b33d-3987-41b9-8ab5-4db78718d6e1_1032x460.png)](https://substackcdn.com/image/fetch/$s_!JVFu!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F3512b33d-3987-41b9-8ab5-4db78718d6e1_1032x460.png)

The context window tends to be at least 8192 tokens and sometimes can scale up to hundreds of thousands of tokens!

A large context window can be used to track the full conversation history as part of the input prompt.

[![Image 21](https://substackcdn.com/image/fetch/$s_!12fR!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F66e6afca-afc6-4a3f-a4b0-4d11e050c558_1204x616.png)](https://substackcdn.com/image/fetch/$s_!12fR!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F66e6afca-afc6-4a3f-a4b0-4d11e050c558_1204x616.png)

This works as long as the conversation history fits within the LLM’s context window and is a nice way of mimicking memory. However, instead of actually memorizing a conversation, we essentially “tell” the LLM what that conversation was.

For models with a smaller context window, or when the conversation history is large, we can instead use another LLM to summarize the conversations that happened thus far.

[![Image 22](https://substackcdn.com/image/fetch/$s_!gJTQ!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F11f97b1d-737b-4843-b8a3-4ad1ac24b173_1320x812.png)](https://substackcdn.com/image/fetch/$s_!gJTQ!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F11f97b1d-737b-4843-b8a3-4ad1ac24b173_1320x812.png)

By continuously summarizing conversations, we can keep the size of this conversation small. It will reduce the number of tokens while keeping track of only the most vital information.

## Long-term Memory

Long-term memory in LLM Agents includes the agent’s past action space that needs to be retained over an extended period.

A common technique to enable long-term memory is to store all previous interactions, actions, and conversations in an external vector database.

To build such a database, conversations are first embedded into numerical representations that capture their meaning.

[![Image 23](https://substackcdn.com/image/fetch/$s_!IqNo!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8420e846-ec02-4101-a0c1-ad9ba1d4a4d7_1028x660.png)](https://substackcdn.com/image/fetch/$s_!IqNo!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8420e846-ec02-4101-a0c1-ad9ba1d4a4d7_1028x660.png)

After building the database, we can embed any given prompt and find the most relevant information in the vector database by comparing the prompt embedding with the database embeddings.

[![Image 24](https://substackcdn.com/image/fetch/$s_!UrYg!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F47304195-33bd-4637-b18e-ad7c57c8aa2c_1028x756.png)](https://substackcdn.com/image/fetch/$s_!UrYg!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F47304195-33bd-4637-b18e-ad7c57c8aa2c_1028x756.png)

This method is often referred to as **Retrieval-Augmented Generation** (RAG).

Long-term memory can also involve retaining information from different sessions. For instance, you might want an LLM Agent to remember any research it has done in previous sessions.

Different types of information can also be related to different types of memory to be stored. In psychology, there are numerous types of memory to differentiate, but the _Cognitive Architectures for Language Agents_ paper coupled four of them to LLM Agents.[2](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-2)

[![Image 25](https://substackcdn.com/image/fetch/$s_!YUIW!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa56c3d15-e512-4bf3-9815-d42cc01ccfa1_1204x416.png)](https://substackcdn.com/image/fetch/$s_!YUIW!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa56c3d15-e512-4bf3-9815-d42cc01ccfa1_1204x416.png)

This differentiation helps in building agentic frameworks. _Semantic memory_ (facts about the world) might be stored in a different database than _working memory_(current and recent circumstances).

# Tools

Tools allow a given LLM to either interact with an external environment (such as databases) or use external applications (such as custom code to run).

[![Image 26](https://substackcdn.com/image/fetch/$s_!9_-k!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F9dfac69b-7b8a-4eee-ad04-8a06ea3be617_1272x176.png)](https://substackcdn.com/image/fetch/$s_!9_-k!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F9dfac69b-7b8a-4eee-ad04-8a06ea3be617_1272x176.png)

Tools generally have two use cases: **fetching data** to retrieve up-to-date information and **taking action** like setting a meeting or ordering food.

To actually use a tool, the LLM has to generate text that fits with the API of the given tool. We tend to expect strings that can be formatted to **JSON** so that it can easily be fed to a **code interpreter**.

[![Image 27](https://substackcdn.com/image/fetch/$s_!bFpp!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F87b42a6f-87a8-4057-8975-969293f73bb2_1460x420.png)](https://substackcdn.com/image/fetch/$s_!bFpp!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F87b42a6f-87a8-4057-8975-969293f73bb2_1460x420.png)

Note that this is not limited to JSON, we can also call the tool in code itself!

You can also generate custom functions that the LLM can use, like a basic multiplication function. This is often referred to as **function calling**.

[![Image 28](https://substackcdn.com/image/fetch/$s_!YXrx!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8152f4a2-34d4-40ee-8445-25b4eed4b179_1460x364.png)](https://substackcdn.com/image/fetch/$s_!YXrx!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8152f4a2-34d4-40ee-8445-25b4eed4b179_1460x364.png)

Some LLMs can use any tools if they are prompted correctly and extensively. Tool-use is something that most current LLMs are capable of.

[![Image 29](https://substackcdn.com/image/fetch/$s_!fNhV!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F20f31f7e-cce9-4c5f-bf94-f46eb635f700_1460x304.png)](https://substackcdn.com/image/fetch/$s_!fNhV!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F20f31f7e-cce9-4c5f-bf94-f46eb635f700_1460x304.png)

A more stable method for accessing tools is by fine-tuning the LLM (more on that later!).

Tools can either be used in a given order if the agentic framework is fixed…

[![Image 30](https://substackcdn.com/image/fetch/$s_!QbA0!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F36192526-b953-4f5a-a2fa-9bde40a827ef_1624x648.png)](https://substackcdn.com/image/fetch/$s_!QbA0!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F36192526-b953-4f5a-a2fa-9bde40a827ef_1624x648.png)

…or the LLM can autonomously choose which tool to use and when. LLM Agents, like the above image, are essentially sequences of LLM calls (but with autonomous selection of actions/tools/etc.).

[![Image 31](https://substackcdn.com/image/fetch/$s_!1FTL!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F36870bf2-e0e5-42d7-bcdc-45b1a1ab7c15_1520x556.png)](https://substackcdn.com/image/fetch/$s_!1FTL!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F36870bf2-e0e5-42d7-bcdc-45b1a1ab7c15_1520x556.png)

In other words, the output of intermediate steps is fed back into the LLM to continue processing.

[![Image 32](https://substackcdn.com/image/fetch/$s_!HZro!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fb5d354e0-d89b-417f-9df7-ffe40985852d_1460x568.png)](https://substackcdn.com/image/fetch/$s_!HZro!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fb5d354e0-d89b-417f-9df7-ffe40985852d_1460x568.png)

## Toolformer

Tool use is a powerful technique for strengthening LLMs' capabilities and compensating for their disadvantages. As such, research efforts on tool use and learning have seen a rapid surge in the last few years.

[![Image 33](https://substackcdn.com/image/fetch/$s_!98Mz!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F0f533a89-9af8-482c-aac6-f1806801b725_1284x820.png)](https://substackcdn.com/image/fetch/$s_!98Mz!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F0f533a89-9af8-482c-aac6-f1806801b725_1284x820.png)

Annotated and cropped picture of the “[Tool Learning with Large Language Models: A Survey](https://arxiv.org/pdf/2405.17935)” paper. With an increasing focus on tool use, (Agentic) LLMs are expected to become more powerful.

Much of this research involves not only prompting LLMs for tool use but training them specifically for tool use instead.

One of the first techniques to do so is called Toolformer, a model trained to decide which APIs to call and how.[3](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-3)

It does so by using the`[`and`]`tokens to indicate the start and end of calling a tool. When given a prompt, for example “_What is 5 times 3?_”, it starts generating tokens until it reaches the`[` token.

[![Image 34](https://substackcdn.com/image/fetch/$s_!HDtU!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4f2fe527-6e4c-45b6-bfcf-ff34c4672c01_1592x208.png)](https://substackcdn.com/image/fetch/$s_!HDtU!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4f2fe527-6e4c-45b6-bfcf-ff34c4672c01_1592x208.png)

After that, it generates tokens until it reaches the`→` token which indicates that the LLM stops generating tokens.

[![Image 35](https://substackcdn.com/image/fetch/$s_!vHXr!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F43bbc573-bebc-4057-82f8-6718be598770_1592x312.png)](https://substackcdn.com/image/fetch/$s_!vHXr!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F43bbc573-bebc-4057-82f8-6718be598770_1592x312.png)

Then, the tool will be called, and the **output** will be added to the tokens generated thus far.

[![Image 36](https://substackcdn.com/image/fetch/$s_!XQpY!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4d88be14-0d49-433c-a2c6-ab0e96b041c0_1592x348.png)](https://substackcdn.com/image/fetch/$s_!XQpY!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4d88be14-0d49-433c-a2c6-ab0e96b041c0_1592x348.png)

The `]`symbol indicates that the LLM can now continue generating if necessary.

Toolformer creates this behavior by carefully generating a dataset with many tool uses the model can train on. For each tool, a few-shot prompt is manually created and used to sample outputs that use these tools.

[![Image 37](https://substackcdn.com/image/fetch/$s_!M2r3!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F20cdf6b6-47d7-4ffd-bc51-b1cb38500bbe_1460x1068.png)](https://substackcdn.com/image/fetch/$s_!M2r3!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F20cdf6b6-47d7-4ffd-bc51-b1cb38500bbe_1460x1068.png)

The outputs are filtered based on correctness of the tool use, output, and loss decrease. The resulting dataset is used to train an LLM to adhere to this format of tool use.

Since the release of Toolformer, there have been many exciting techniques such as LLMs that can use thousands of tools (ToolLLM[4](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-4)) or LLMs that can easily retrieve the most relevant tools (Gorilla[5](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-5)).

Either way, most current LLMs (beginning of 2025) have been trained to call tools easily through JSON generation (as we saw before).

## Model Context Protocol (MCP)

Tools are an important component of Agentic frameworks, allowing LLMs to interact with the world and extend their capabilities. However, enabling tool use when you have many different API becomes troublesome as any tool needs to be:

*   Manually **tracked** and fed to the LLM

*   Manually **described** (including its expected JSON schema)

*   Manually **updated** whenever its API changes

[![Image 38](https://substackcdn.com/image/fetch/$s_!u9H9!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4392e0ed-f13e-4f6c-9b26-7804498a94ae_1624x828.png)](https://substackcdn.com/image/fetch/$s_!u9H9!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4392e0ed-f13e-4f6c-9b26-7804498a94ae_1624x828.png)

To make tools easier to implement for any given Agentic framework, Anthropic developed the Model Context Protocol (MCP).[6](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-6) MCP standardizes API access for services like weather apps and GitHub.

It consists of three components:

*   MCP **Host** — LLM application (such as Cursor) that manages connections

*   MCP **Client** — Maintains 1:1 connections with MCP servers

*   MCP **Server** — Provides context, tools, and capabilities to the LLMs

[![Image 39](https://substackcdn.com/image/fetch/$s_!qiyP!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F24c1c103-b26f-4fb2-8089-6a5b0696a99f_1624x764.png)](https://substackcdn.com/image/fetch/$s_!qiyP!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F24c1c103-b26f-4fb2-8089-6a5b0696a99f_1624x764.png)

For example, let’s assume you want a given LLM application to summarize the 5 latest commits from your repository.

The MCP Host (together with the client) would first call the MCP Server to ask which tools are available.

[![Image 40](https://substackcdn.com/image/fetch/$s_!ueYB!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F2ecb19e6-53fd-414e-a729-dab86c43b189_1624x780.png)](https://substackcdn.com/image/fetch/$s_!ueYB!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F2ecb19e6-53fd-414e-a729-dab86c43b189_1624x780.png)

The LLM receives the information and may choose to use a tool. It sends a request to the MCP Server via the Host, then receives the results, including the tool used.

[![Image 41](https://substackcdn.com/image/fetch/$s_!uMt6!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F7bf83696-db99-437a-bd3e-7c638f6445b6_1624x616.png)](https://substackcdn.com/image/fetch/$s_!uMt6!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F7bf83696-db99-437a-bd3e-7c638f6445b6_1624x616.png)

Finally, the LLM receives the results and can parse an answer to the user.

[![Image 42](https://substackcdn.com/image/fetch/$s_!9UB_!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F29c46b51-7d88-403e-8e47-2eb82e1bb6a7_1624x616.png)](https://substackcdn.com/image/fetch/$s_!9UB_!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F29c46b51-7d88-403e-8e47-2eb82e1bb6a7_1624x616.png)

This framework makes creating tools easier by connecting to MCP Servers that any LLM application can use. So when you create an MCP Server to interact with Github, any LLM application that supports MCP can use it.

# Planning

Tool use allows an LLM to increase its capabilities. They are typically called using JSON-like requests.

But how does the LLM, in an agentic system, decide which tool to use and when?

This is where planning comes in. Planning in LLM Agents involves breaking a given task up into actionable steps.

[![Image 43](https://substackcdn.com/image/fetch/$s_!QZSw!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F39a6b7eb-0700-4cde-bbe3-59b6d99baee8_1460x540.png)](https://substackcdn.com/image/fetch/$s_!QZSw!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F39a6b7eb-0700-4cde-bbe3-59b6d99baee8_1460x540.png)

This plan allows the model to iteratively reflect on past behavior and update the current plan if necessary.

[![Image 44](https://substackcdn.com/image/fetch/$s_!cYaZ!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe521c2fc-6aee-435f-833f-8247b12d1e5d_1460x224.png)](https://substackcdn.com/image/fetch/$s_!cYaZ!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe521c2fc-6aee-435f-833f-8247b12d1e5d_1460x224.png)

I love it when a plan comes together!

To enable planning in LLM Agents, let’s first look at the foundation of this technique, namely reasoning.

## Reasoning

Planning actionable steps requires complex reasoning behavior. As such, the LLM must be able to showcase this behavior before taking the next step in planning out the task.

“Reasoning” LLMs are those that tend to “think” before answering a question.

[![Image 45](https://substackcdn.com/image/fetch/$s_!cFyW!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8cdd114b-427f-454f-9e85-ee5d241d266f_1668x1060.png)](https://substackcdn.com/image/fetch/$s_!cFyW!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8cdd114b-427f-454f-9e85-ee5d241d266f_1668x1060.png)

I am using the terms “reasoning” and “thinking” a bit loosely as we can argue whether this is human-like thinking or merely breaking the answer down to structured steps.

This reasoning behavior can be enabled by roughly two choices: fine-tuning the LLM or specific prompt engineering.

With prompt engineering, we can create examples of the reasoning process that the LLM should follow. Providing examples (also called few-shot prompting[7](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-7)) is a great method for steering the LLM’s behavior.

[![Image 46](https://substackcdn.com/image/fetch/$s_!GMcl!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa05700ec-3ef5-4071-80b3-f97093196928_1480x748.png)](https://substackcdn.com/image/fetch/$s_!GMcl!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa05700ec-3ef5-4071-80b3-f97093196928_1480x748.png)

This methodology of providing examples of thought processes is called Chain-of-Thought and enables more complex reasoning behavior.[8](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-8)

Chain-of-thought can also be enabled without any examples (zero-shot prompting) by simply stating “Let’s think step-by-step”.[9](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-9)

[![Image 47](https://substackcdn.com/image/fetch/$s_!QUTT!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F028e3be4-f1f5-451a-b441-20fcae781aac_1648x280.png)](https://substackcdn.com/image/fetch/$s_!QUTT!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F028e3be4-f1f5-451a-b441-20fcae781aac_1648x280.png)

When training an LLM, we can either give it a sufficient amount of datasets that include thought-like examples or the LLM can discover its own thinking process.

A great example is DeepSeek-R1 where rewards are used to guide the usage of thinking processes.

[![Image 48](https://substackcdn.com/image/fetch/$s_!0bpi!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5a85a363-4c76-4b73-8532-ffe863948882_1628x972.png)](https://substackcdn.com/image/fetch/$s_!0bpi!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5a85a363-4c76-4b73-8532-ffe863948882_1628x972.png)

For more information about Reasoning LLMs, see my [visual guide](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms).

[![Image 49: A Visual Guide to Reasoning LLMs](https://substackcdn.com/image/fetch/$s_!Gvlc!,w_140,h_140,c_fill,f_auto,q_auto:good,fl_progressive:steep,g_auto/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F10912af1-1648-44e2-9cfc-af1c5b2a5aa8_1020x729.png) #### A Visual Guide to Reasoning LLMs [Maarten Grootendorst](https://substack.com/profile/14309499-maarten-grootendorst) · February 3, 2025 [Read full story](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms)](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms)

## Reasoning and Acting

Enabling reasoning behavior in LLMs is great but does not necessarily make it capable of planning actionable steps.

The techniques we focused on thus far either showcase reasoning behavior or interact with the environment through tools.

[![Image 50](https://substackcdn.com/image/fetch/$s_!Lo8s!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5e3d90c2-c007-4fef-a8df-176d68ae5fd6_1844x652.png)](https://substackcdn.com/image/fetch/$s_!Lo8s!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5e3d90c2-c007-4fef-a8df-176d68ae5fd6_1844x652.png)

Chain-of-Thought, for instance, is focused purely on reasoning.

One of the first techniques to combine both processes is called ReAct (Reason and Act).[10](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-10)

[![Image 51](https://substackcdn.com/image/fetch/$s_!zf6J!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fca0a3091-bcf9-4da6-9a28-242d82f12acf_1844x652.png)](https://substackcdn.com/image/fetch/$s_!zf6J!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fca0a3091-bcf9-4da6-9a28-242d82f12acf_1844x652.png)

ReAct does so through careful prompt engineering. The ReAct prompt describes three steps:

*   **Thought** - A reasoning step about the current situation

*   **Action** - A set of actions to execute (e.g., tools)

*   **Observation** - A reasoning step about the result of the action

The prompt itself is then quite straightforward.

[![Image 52](https://substackcdn.com/image/fetch/$s_!e6h_!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F95450e98-4045-4fb6-b866-5aed129e5a7c_1404x824.png)](https://substackcdn.com/image/fetch/$s_!e6h_!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F95450e98-4045-4fb6-b866-5aed129e5a7c_1404x824.png)

The LLM uses this prompt (which can be used as a system prompt) to steer its behaviors to work in cycles of thoughts, actions, and observations.

[![Image 53](https://substackcdn.com/image/fetch/$s_!og78!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F77b17db6-da65-4afb-a775-e6a939f1ea58_1900x1168.png)](https://substackcdn.com/image/fetch/$s_!og78!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F77b17db6-da65-4afb-a775-e6a939f1ea58_1900x1168.png)

It continues this behavior until an action specifies to return the result. By iterating over thoughts and observations, the LLM can plan out actions, observe its output, and adjust accordingly.

As such, this framework enables LLMs to demonstrate more autonomous agentic behavior compared to Agents with predefined and fixed steps.

## Reflecting

Nobody, not even LLMs with ReAct, will perform every task perfectly. Failing is part of the process as long as you can reflect on that process.

This process is missing from ReAct and is where Reflexion comes in. Reflexion is a technique that uses verbal reinforcement to help agents learn from prior failures.[11](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-11)

The method assumes three LLM roles:

*   **Actor** — Chooses and executes actions based on state observations. We can use methods like Chain-of-Thought or ReAct.

*   **Evaluator** — Scores the outputs produced by the Actor.

*   **Self-reflection** — Reflects on the action taken by the Actor and scores generated by the Evaluator.

[![Image 54](https://substackcdn.com/image/fetch/$s_!2Fl8!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fb22cf4df-37b1-4359-8417-084a77248232_1176x588.png)](https://substackcdn.com/image/fetch/$s_!2Fl8!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fb22cf4df-37b1-4359-8417-084a77248232_1176x588.png)

Memory modules are added to track actions (short-term) and self-reflections (long-term), helping the Agent learn from its mistakes and identify improved actions.

A similar and elegant technique is called SELF-REFINE, where actions of refining output and generating feedback are repeated.[12](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-12)

[![Image 55](https://substackcdn.com/image/fetch/$s_!nq6T!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F36c8b4af-5ca1-46e9-a5b6-e5ff94c8e32a_1484x580.png)](https://substackcdn.com/image/fetch/$s_!nq6T!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F36c8b4af-5ca1-46e9-a5b6-e5ff94c8e32a_1484x580.png)

The same LLM is in charge of generating the initial output, the refined output, and feedback.

[![Image 56](https://substackcdn.com/image/fetch/$s_!2TP0!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F6b713a88-5805-4e5b-984c-f377d2d59386_1736x652.png)](https://substackcdn.com/image/fetch/$s_!2TP0!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F6b713a88-5805-4e5b-984c-f377d2d59386_1736x652.png)

Annotated figure of the “[SELF-REFINE: Iterative Refinement with Self-Feedback](https://proceedings.neurips.cc/paper_files/paper/2023/file/91edff07232fb1b55a505a9e9f6c0ff3-Paper-Conference.pdf)” paper. 

Interestingly, this self-reflective behavior, both Reflexion and SELF-REFINE, closely resembles that of reinforcement learning where a reward is given based on the quality of the output.

# Multi-Agent Collaboration

The single Agent we explored has several issues: too many tools may complicate selection, context becomes too complex, and the task may require specialization.

Instead, we can look towards **Multi-Agents**, frameworks where multiple agents (each with access to **tools**, **memory**, and **planning**) are interacting with each other and their environments:

[![Image 57](https://substackcdn.com/image/fetch/$s_!VBb7!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fb028b7eb-eeec-492c-816b-1c0837be2b40_1228x716.png)](https://substackcdn.com/image/fetch/$s_!VBb7!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fb028b7eb-eeec-492c-816b-1c0837be2b40_1228x716.png)

These Multi-Agent systems usually consist of specialized Agents, each equipped with their own toolset and overseen by a supervisor. The supervisor manages communication between Agents and can assign specific tasks to the specialized Agents.

[![Image 58](https://substackcdn.com/image/fetch/$s_!c6AX!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa15cb88d-c059-41dc-b658-f643ad076588_1228x504.png)](https://substackcdn.com/image/fetch/$s_!c6AX!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa15cb88d-c059-41dc-b658-f643ad076588_1228x504.png)

Each Agent might have different types of tools available, but there might also be different memory systems.

In practice, there are dozens of Multi-Agent architectures with two components at their core:

*   Agent **Initialization** — How are individual (specialized) Agents created?

*   Agent **Orchestration** — How are all Agents coordinated?

[![Image 59](https://substackcdn.com/image/fetch/$s_!WJPG!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F17b03793-5c78-45d0-b79a-52901c288201_1228x652.png)](https://substackcdn.com/image/fetch/$s_!WJPG!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F17b03793-5c78-45d0-b79a-52901c288201_1228x652.png)

Let’s explore various interesting Multi-Agent frameworks and highlight how these components are implemented.

## Interactive Simulacra of Human Behavior

Arguably one of the most influential, and frankly incredibly cool, Multi-Agent papers is called “[Generative Agents: Interactive Simulacra of Human Behavior](https://arxiv.org/pdf/2304.03442)”.[13](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-13)

In this paper, they created computational software agents that simulate believable human behavior, which they call Generative Agents.

[![Image 60](https://substackcdn.com/image/fetch/$s_!XRHD!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fd427f53c-35b9-4253-aa2a-8cd566e8b129_1156x252.png)](https://substackcdn.com/image/fetch/$s_!XRHD!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fd427f53c-35b9-4253-aa2a-8cd566e8b129_1156x252.png)

The **profile** each Generative Agent is given makes them behave in unique ways and helps create more interesting and dynamic behavior.

Each Agent is initialized with three modules (**memory**, **planning**, and **reflection**) very much like the core components that we have seen previously with ReAct and Reflexion.

[![Image 61](https://substackcdn.com/image/fetch/$s_!ejBh!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8a42fc17-5d98-40f4-a350-a2d4fe2f8890_1324x732.png)](https://substackcdn.com/image/fetch/$s_!ejBh!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F8a42fc17-5d98-40f4-a350-a2d4fe2f8890_1324x732.png)

The Memory module is one of the most vital components in this framework. It stores both the planning and reflection behaviors, as well as all events thus far.

For any given next step or question, memories are retrieved and scored on their recency, importance, and relevance. The highest scoring memories are shared with the Agent.

[![Image 62](https://substackcdn.com/image/fetch/$s_!ozzI!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe0746e39-a6d5-4a5c-9336-cae884f250d7_1496x1356.png)](https://substackcdn.com/image/fetch/$s_!ozzI!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe0746e39-a6d5-4a5c-9336-cae884f250d7_1496x1356.png)

Annoted figure of the [Generative Agents: Interactive Simulacra of Human Behavior](https://arxiv.org/pdf/2304.03442) paper.

Together, they allow for Agents to freely go about their behavior and interact with one another. As such, there is very little Agent orchestration as they do not have specific goals to work to.

[![Image 63](https://substackcdn.com/image/fetch/$s_!8yh2!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fffdf51e4-c348-46a5-94ed-3c3d091da550_2536x1052.png)](https://substackcdn.com/image/fetch/$s_!8yh2!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fffdf51e4-c348-46a5-94ed-3c3d091da550_2536x1052.png)

Annotated image from the [interactive demo](https://reverie.herokuapp.com/arXiv_Demo/).

There are too many amazing snippets of information in this paper, but I want to highlight their evaluation metric.[14](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-14)

Their evaluation involved the believability of the Agent’s behaviors as the main metric, with human evaluators scoring them.

[![Image 64](https://substackcdn.com/image/fetch/$s_!bCFn!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F98b3af2a-bd4b-4d30-a83b-c9300c8df2ce_1076x716.png)](https://substackcdn.com/image/fetch/$s_!bCFn!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F98b3af2a-bd4b-4d30-a83b-c9300c8df2ce_1076x716.png)

Annotated figure of the [Generative Agents: Interactive Simulacra of Human Behavior](https://arxiv.org/pdf/2304.03442) paper.

It showcases how important observation, planning, and reflection are together in the performance of these Generative Agents. As explored before, planning is not complete without reflective behavior.

## Modular Frameworks

Whatever framework you choose for creating Multi-Agent systems, they are generally composed of several ingredients, including its profile, perception of the environment, memory, planning, and available actions.[15](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-15)[16](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-16)

[![Image 65](https://substackcdn.com/image/fetch/$s_!RhGD!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F16d08b46-3c57-434e-aa73-7a1e516305c7_1232x656.png)](https://substackcdn.com/image/fetch/$s_!RhGD!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F16d08b46-3c57-434e-aa73-7a1e516305c7_1232x656.png)

Popular frameworks for implementing these components are AutoGen[17](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-17), MetaGPT[18](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-18), and CAMEL[19](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-19). However, each framework approaches communication between each Agent a bit differently.

With CAMEL, for instance, the user first creates its question and defines **AI User** and **AI Assistant** roles. The AI user role represents the human user and will guide the process.

[![Image 66](https://substackcdn.com/image/fetch/$s_!p2ZY!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Faa8b7a80-9b4e-402b-a0da-b6ae21e8464a_1232x236.png)](https://substackcdn.com/image/fetch/$s_!p2ZY!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Faa8b7a80-9b4e-402b-a0da-b6ae21e8464a_1232x236.png)

After that, the AI User and AI Assistant will collaborate on resolving the query by interacting with each other.

[![Image 67](https://substackcdn.com/image/fetch/$s_!bpu_!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F6bcc2339-cf84-4099-915b-ccd1c7417ff9_1232x648.png)](https://substackcdn.com/image/fetch/$s_!bpu_!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F6bcc2339-cf84-4099-915b-ccd1c7417ff9_1232x648.png)

This role-playing methodology enables collaborative communication between agents.

AutoGen and MetaGPT have different methods of communication, but it all boils down to this collaborative nature of communication. Agents have opportunities to engage and talk with one another to update their current status, goals, and next steps.

In the last year, and especially the last few weeks, the growth of these frameworks has been explosive.

[![Image 68](https://substackcdn.com/image/fetch/$s_!5WEu!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fddc3ddb2-40f6-4e4a-b463-92bf902cda54_1044x700.png)](https://substackcdn.com/image/fetch/$s_!5WEu!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fddc3ddb2-40f6-4e4a-b463-92bf902cda54_1044x700.png)

2025 is going to be a truly exciting year as these frameworks keep maturing and developing!

# **Conclusion**

This concludes our journey of LLM Agents! Hopefully, this post gives a better understanding of how LLM Agents are built.

To see more visualizations related to LLMs and to support this newsletter, check out the book I wrote on Large Language Models!

[![Image 69](https://substackcdn.com/image/fetch/$s_!MdLW!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa0b260f5-da52-4186-bc06-fd22077b2737_590x768.jpeg)](https://substackcdn.com/image/fetch/$s_!MdLW!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa0b260f5-da52-4186-bc06-fd22077b2737_590x768.jpeg)

[Official website](https://www.llm-book.com/) of the book. You can order the book on [Amazon](https://www.amazon.com/Hands-Large-Language-Models-Understanding/dp/1098150961). All code is uploaded to [GitHub](https://github.com/handsOnLLM/Hands-On-Large-Language-Models).

[1](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-1)

Russell, S. J., & Norvig, P. (2016). _Artificial intelligence: a modern approach_. pearson.

[2](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-2)

Sumers, Theodore, et al. "Cognitive architectures for language agents." _Transactions on Machine Learning Research_ (2023).

[3](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-3)

Schick, Timo, et al. "Toolformer: Language models can teach themselves to use tools." _Advances in Neural Information Processing Systems_ 36 (2023): 68539-68551.

[4](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-4)

Qin, Yujia, et al. "Toolllm: Facilitating large language models to master 16000+ real-world apis." _arXiv preprint arXiv:2307.16789_ (2023).

[5](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-5)

Patil, Shishir G., et al. "Gorilla: Large language model connected with massive apis." _Advances in Neural Information Processing Systems_ 37 (2024): 126544-126565.

[6](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-6)

"Introducing the Model Context Protocol." _Anthropic_, www.anthropic.com/news/model-context-protocol. Accessed 13 Mar. 2025.

[7](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-7)

Mann, Ben, et al. "Language models are few-shot learners." _arXiv preprint arXiv:2005.14165_ 1 (2020): 3.

[8](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-8)

Wei, Jason, et al. "Chain-of-thought prompting elicits reasoning in large language models." _Advances in neural information processing systems_ 35 (2022): 24824-24837.

[9](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-9)

Kojima, Takeshi, et al. "Large language models are zero-shot reasoners." _Advances in neural information processing systems_ 35 (2022): 22199-22213.

[10](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-10)

Yao, Shunyu, Zhao, Jeffrey, Yu, Dian, Du, Nan, Shafran, Izhak, Narasimhan, Karthik, and Cao, Yuan. _ReAct: Synergizing Reasoning and Acting in Language Models_. Retrieved from https://par.nsf.gov/biblio/10451467. _International Conference on Learning Representations (ICLR)_.

[11](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-11)

Shinn, Noah, et al. "Reflexion: Language agents with verbal reinforcement learning." _Advances in Neural Information Processing Systems_ 36 (2023): 8634-8652.

[12](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-12)

Madaan, Aman, et al. "Self-refine: Iterative refinement with self-feedback." _Advances in Neural Information Processing Systems_ 36 (2023): 46534-46594.

[13](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-13)

Park, Joon Sung, et al. "Generative agents: Interactive simulacra of human behavior." _Proceedings of the 36th annual acm symposium on user interface software and technology_. 2023.

[14](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-14)

To see a cool interactive playground of the Generative Agents, follow this link: [https://reverie.herokuapp.com/arXiv_Demo/](https://reverie.herokuapp.com/arXiv_Demo/)

[15](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-15)

Wang, Lei, et al. "A survey on large language model based autonomous agents." _Frontiers of Computer Science_ 18.6 (2024): 186345.

[16](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-16)

Xi, Zhiheng, et al. "The rise and potential of large language model based agents: A survey." _Science China Information Sciences_ 68.2 (2025): 121101.

[17](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-17)

Wu, Qingyun, et al. "Autogen: Enabling next-gen llm applications via multi-agent conversation." _arXiv preprint arXiv:2308.08155_ (2023).

[18](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-18)

Hong, Sirui, et al. "Metagpt: Meta programming for multi-agent collaborative framework." _arXiv preprint arXiv:2308.00352_ 3.4 (2023): 6.

[19](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents#footnote-anchor-19)

Li, Guohao, et al. "Camel: Communicative agents for" mind" exploration of large language model society." _Advances in Neural Information Processing Systems_ 36 (2023): 51991-52008.

* * *

#### Subscribe to Exploring Language Models

By Maarten Grootendorst · Launched 3 years ago

ML Engineer writing about GenAI | Open Sourcerer (BERTopic, PolyFuzz, KeyBERT) | Author of "Hands-On Large Language Models".

Subscribe

By subscribing, you agree Substack's [Terms of Use](https://substack.com/tos), and acknowledge its [Information Collection Notice](https://substack.com/ccpa#personal-data-collected) and [Privacy Policy](https://substack.com/privacy).

 

[![Image 70: C.K. Tse's avatar](https://substackcdn.com/image/fetch/$s_!APtI!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F9f52f86d-3644-4da0-96d8-08e003dd00cb_144x144.png)](https://substack.com/profile/45486752-ck-tse)[![Image 71: MICHELE SBLENDORIO's avatar](https://substackcdn.com/image/fetch/$s_!rR3i!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F50912a6c-0d34-477c-bc39-006331d2648f_96x96.png)](https://substack.com/profile/14099549-michele-sblendorio)[![Image 72: SAMeh Zaghloul's avatar](https://substackcdn.com/image/fetch/$s_!Mgkn!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa95e7d9d-6b94-46c7-a5c6-88f9b3a21f00_144x144.png)](https://substack.com/profile/29111314-sameh-zaghloul)[![Image 73: Ihor's avatar](https://substackcdn.com/image/fetch/$s_!hax6!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F6ea605a9-e5c3-461b-9f84-e8d7776720aa_144x144.png)](https://substack.com/profile/14042337-ihor)[![Image 74: 蓝屿's avatar](https://substackcdn.com/image/fetch/$s_!bHPO!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F81ee0613-174e-4559-ae57-787698976f5b_896x896.jpeg)](https://substack.com/profile/31679311-84dd5c7f)

[597 Likes](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents)∙

[71 Restacks](https://substack.com/note/p-156659273/restacks?utm_source=substack&utm_content=facepile-restacks)

597

23

71

Share

Previous Next

#### Discussion about this post

Comments Restacks

![Image 75: User's avatar](https://substackcdn.com/image/fetch/$s_!TnFC!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack.com%2Fimg%2Favatars%2Fdefault-light.png)

[![Image 76: Srikanth's avatar](https://substackcdn.com/image/fetch/$s_!n7Iv!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack.com%2Fimg%2Favatars%2Fblack.png)](https://substack.com/profile/17130219-srikanth?utm_source=comment)

[Srikanth](https://substack.com/profile/17130219-srikanth?utm_source=substack-feed-item)

[Mar 20, 2025](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents/comment/102078496 "Mar 20, 2025, 8:54 PM")

Liked by Maarten Grootendorst

Great work, thank you so much for explaining complex subjects on AI in more detail and engaging way. Started reading the book in o’reily online(as it is not available in india for purchase) 😀

[Like (2)](javascript:void(0))[Reply](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents)[Share](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents)

[3 replies by Maarten Grootendorst and others](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents/comment/102078496)

[![Image 77: Benjamin's avatar](https://substackcdn.com/image/fetch/$s_!ryS2!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack.com%2Fimg%2Favatars%2Fyellow.png)](https://substack.com/profile/329656111-benjamin?utm_source=comment)

[Benjamin](https://substack.com/profile/329656111-benjamin?utm_source=substack-feed-item)

[Apr 1, 2025](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents/comment/105019921 "Apr 1, 2025, 8:18 AM")

Liked by Maarten Grootendorst

well，so clearly!I I really appreciate your work！

[Like (1)](javascript:void(0))[Reply](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents)[Share](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents)

[21 more comments...](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents/comments)

Top Latest Discussions

[A Visual Guide to Mamba and State Space Models](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mamba-and-state)

[An Alternative to Transformers for Language Modeling](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mamba-and-state)

Feb 19, 2024•[Maarten Grootendorst](https://substack.com/@maartengrootendorst)

376

24

33

![Image 78](https://substackcdn.com/image/fetch/$s_!iw2m!,w_320,h_213,c_fill,f_auto,q_auto:good,fl_progressive:steep,g_center/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F89fbbc95-d92f-49f4-833b-cfa37b3f0644_1148x892.png)

[A Visual Guide to Quantization](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization)

[Exploring memory-efficient techniques for LLMs](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization)

Jul 22, 2024•[Maarten Grootendorst](https://substack.com/@maartengrootendorst)

523

26

44

![Image 79](https://substackcdn.com/image/fetch/$s_!yYxw!,w_320,h_213,c_fill,f_auto,q_auto:good,fl_progressive:steep,g_center/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe9d17077-d9af-4b37-9b9b-57ef9aaa1ca9_680x486.png)

[A Visual Guide to Mixture of Experts (MoE)](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mixture-of-experts)

[Demystifying the role of MoE in Large Language Models](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mixture-of-experts)

Oct 7, 2024•[Maarten Grootendorst](https://substack.com/@maartengrootendorst)

436

21

45

![Image 80](https://substackcdn.com/image/fetch/$s_!o-PE!,w_320,h_213,c_fill,f_auto,q_auto:good,fl_progressive:steep,g_center/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F50a9eba8-8490-4959-8cda-f0855af65d67_1360x972.png)

See all

### Ready for more?

Subscribe

© 2026 Maarten Grootendorst · [Privacy](https://substack.com/privacy) ∙ [Terms](https://substack.com/tos) ∙ [Collection notice](https://substack.com/ccpa#personal-data-collected)

[Start your Substack](https://substack.com/signup?utm_source=substack&utm_medium=web&utm_content=footer)[Get the app](https://substack.com/app/app-store-redirect?utm_campaign=app-marketing&utm_content=web-footer-button)

[Substack](https://substack.com/) is the home for great culture
