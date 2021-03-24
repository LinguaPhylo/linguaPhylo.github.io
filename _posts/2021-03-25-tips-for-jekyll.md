---
layout: post
title:  "Tips to write tutorials"
date:   2021-03-25
categories: tutorials
---

The LPhyBEAST tutorials are written on a [Kramdown](https://kramdown.gettalong.org/syntax.html) format,
and rendered automatically by [Jekyll](https://jekyllrb.com/docs/). 
Its [Step by Step Tutorial](https://jekyllrb.com/docs/step-by-step/01-setup/) 
will help beginners to get started quickly.
It is supporting [Liquid](https://shopify.github.io/liquid/basics/introduction/) 
and [MathJax](http://docs.mathjax.org/en/latest/input/tex/index.html).

## Reusing templates

When you start to write your own tutorial for new models in LPhy or LPhyBEAST, 
please consider to reuse the existing [templates](/templates) first, 
if necessary, you are welcome to create new templates.

To reuse these templates in your main markdown file, 
you can simply copy the example below using a template [lphy-beast.md](templates/lphy-beast.md):

```
{% include_relative templates/lphy-beast.md lphy="hcv_coal" %}
```

As you can see, [lphy-beast.md](templates/lphy-beast.md) has 1 variable `lphy`, 
which is declared as `{{include.lphy}}` in the template. 
The prefix `include` is always required for any variables.

Then, given `lphy="hcv_coal"`, this variable will be replaced to `hcv_coal` 
when the corresponding HTML page is created.


## Auto-numbering figures

[Liquid](https://shopify.github.io/liquid/basics/introduction/) is so powerful, 
if you embed the following code into your markdown, 
Jekyll will automatically create the correct numbers for figures, 
even though you would change their ordering later. 

Assign 1 to the variable `current_fig_num`:

```
{% assign current_fig_num = 1 %} 
```

Then append "Figure " before 1:

```
{% assign bs1_fig_num = "Figure " | append: current_fig_num  %}
```

So you will have "Figure 1" in your first figure caption:

```
<figure class="image" id="bs1_fig">
  <img src="BS1.png" alt="Bayesian Skyline">
  <figcaption>{{ bs1_fig_num }}: ... </figcaption>
</figure>
```

For the rest of numbers, just add 1 each time before you use it:

```
{% assign current_fig_num = current_fig_num | plus: 1 %}
```

If you want to refer to this figure in the context, 
you can define another variable to keep its value, such as

```
{% assign pop_fig_num = "Figure " | append: current_fig_num  %}
```

In practice, whatever you move, add, or delete your figures, 
as long as `plus: 1` is correctly distributed, 
you do not have to manually check and correct these numbers anymore.    
<span style='font-size:10px;'>&#128513;</span>

## Writing math in Latex 

You can directly write math symbols and equations in your tutorial markdown file,
indicated by special delimiters like \$\$...\$\$ or \$...\$ for inline.

The detail is described in [MathJax doc](http://docs.mathjax.org/en/latest/input/tex/index.html).
 

## Auto-generated narrative 

NarrativeCreator inside LPhy project can automatically create a narrative for data and graphical models 
defined in a lphy script.

```
NarrativeCreator tutorials/h5n1.lphy
```

The program will create lphy.md, narrative.md, and references.md. 
You can include them into your tutorial, 
to save some efforts for common introductions and references.

