# Stance Classification of Tweets using Transfer Learning
Applying transfer learning (using existing neural network architectures) 
to perform stance classification of Tweets as per the [SemEval 2016 Stance Detection Task](http://alt.qcri.org/semeval2016/task6/).

[The methodology is described in detail in this Medium post](https://towardsdatascience.com/transfer-learning-in-nlp-for-tweet-stance-classification-8ab014da8dde) and compared (in detail) the transfer learning approaches used.

For subtask A, the goal is to classify Tweets in response to a particular topic into one of three classes: *Favor*, 
*Against* and *None*. The provided notebooks attempt this using a technique in deep learning called *transfer learning*.
While transfer learning has been ubiquitous throughout computer vision applications since the success of ImageNet, it is only 
since 2017-18 that significant progress has been made for transfer learning in NLP applications. There have been a string of 
interesting papers in 2018 that discuss the power of language models in natural language understanding and how they can be 
used to provide pre-trained representations of a language's syntax, which can be far more useful when training a neural 
network for previously unseen tasks.

## Analysis Notebooks

See the included Jupyter notebooks for the stance classification workflow using 
ULMFit and the OpenAI transformer.

**Method 1: ULMFiT**

[ulmfit.ipynb](https://github.com/prrao87/tweet-stance-prediction/blob/master/ulmfit.ipynb): (LSTM-based approach)

**Method 2: OpenAI Transformer** 

[transformer.ipynb](https://github.com/prrao87/tweet-stance-prediction/blob/master/transformer.ipynb): (Transformer-based approach)

### Module Installation

The below sections highlight the installation steps for each approach used. 
Python 3.6+ and PyTorch 1.0.0 is used for all the work shown.

Set up virtual environment:

    python3 -m venv venv
    source venv/bin/activate
    pip3 install -r requirements.txt

Once virtual environment has been set up, activate it for further development.

    source venv/bin/activate

## PyTorch requirements
Install the latest version of ```pytorch``` (1.0+) as shown below:

    pip3 install -r pytorch-requirements.txt

## ULMFit with the *fastai* framework

This utilizes the *fastai* framework (built on top of PyTorch) to perform
stance classification. 

The notebook ```ulmfit.ipynb``` uses **v1** of ```fastai```, which has been 
refactored for efficiency and updated to move forward with future PyTorch versions (1.0+).

Install ```fastai``` as shown below:

    pip3 install fastai

## spaCy language model

For tokenization, ```fastai``` uses the SpaCy library's English language model. This has
to be downloaded manually:

    python3 -m spacy download en 

## Evaluation

To evaluate the F1 score as per the SemEval 2016 Task 6 guidelines, use the *perl* 
script given in ```data/eval/``` as shown:

    perl eval.pl -u

    ---------------------------
    Usage:
    perl eval.pl goldFile guessFile

    goldFile:  file containing gold standards;
    guessFile: file containing your prediction.

    These two files have the same format:
    ID<Tab>Target<Tab>Tweet<Tab>Stance
    Only stance labels may be different between them!
    ---------------------------

