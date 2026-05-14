#import "@preview/latexlike-report:1.0.0": *

#show: latexlike-report.with(
 
 // ======== Cover ============
 //Use content [] or none, except in author.
  author: "Corentin VAILLANT, Julien LEFEBVRE", // must be a string ("")
  title: [Rapport TER],
  subtitle: [Approche moderne du rendu différentiel],
  
  affiliation: [Université de Toulouse],
  year: [2026],
  class: [L3 MIDL],
  other: [Encadrant : Mathias PAULIN],

  date: [2026], // You could use #datetime.today().display() for the date.

  logo : image("Images/LogoFSI.png"),

  //==========Theme ===============
  theme-color: rgb("#000000"),
  lang: "fr", 
   participants-supplement: "Auteurs:", //Change it if you change the language
 
            
  //=========Font =================
  title-font: "New Computer Modern",
  font: "New Computer Modern",
  font-size : 13pt,
  font-weight: 400,

  //============ Math =============

  math-font: "New Computer Modern Math",
  math-weight: 400,
  math-ref-supplement: auto, //Use none for no supplement, auto for language based or any other function or string you like
  math-numbering: "(1.1)", // The numbering style you like
  
  // ---- Equate package ---
  // For more information, you can refer to equate documentation
  
  math-number-mode: "label", //Can be "label" or "line" 
  math-sub-numbering: true,  // true or false

  //===========Page style===============
  pagebreak-section: true, //For pagebreak after adding a new level one heading (=)
  show-outline:true, //true or false 
  page-paper:"a4",

  //-----chic header package----
  // customize the left/center/right header and left/center/right footer
  // you can add images, text, the number of the current page, etc, or put none if you don't want some part of the header or footer.
  //some usefull function: chic-page-number(), chic-heading-name()
  
  h-l : [#smallcaps[Rapport TER]],
  h-r :[#image("Images/PetitLogoFSI.png",width: 14%)],
  h-c : none,

  f-l : [],
  f-r : [],
  f-c : chic-page-number(),
  //=======================================
  //For more customitation you can check the documentation. !! Enjoy :D !!
)

#let raytracing_in_one_weekend = link("https://raytracing.github.io/")[*Raytracing in one weekend*]
#let shaung_zhao = link("https://projects.shuangz.com/psdr-sg20/")[*Path-Space Differentiable Rendering*]
#let rtvk = link("https://github.com/CorentinVaillant/RtVk")[*GitHub du Path Tracer*]
#let suisses = link("https://rgl.epfl.ch/publications/Zeltner2021MonteCarlo")[*Monte Carlo Estimators for Differential Light Transport*]


= Introduction

Le rendu différentiel est une branche de l'informatique graphique où l'on cherche à trouver 
la différentielle de l'image d'un rendu d'une scène, ce qui est très utile dans de nombreux domaines. 
Il possède de nombreuses applications, notamment dans le rendu plus classique, car il permet de faire varier des paramètres de la scène sans obligation de rendre la scène une nouvelle fois de zéro, ce qui peut être très couteux.
Il est aussi utile dans le rendu physiquement réaliste parce qu'il a permis de résoudre des problèmes d'analyse-par-synthèse dans des domaines comme le rendu de vêtements ou encore la création de matériaux translucides. 
Son utilité ne se limite pas qu'au rendu, il possède aussi des applications dans le domaine du machine learning car il permet  d'entrainer des réseaux de neurones de manière plus efficace.
Le rendu différentiel a une communauté de recherche très active. 
En effet ce domaine est très challengeant parce qu'à ce jour aucun algorithme efficace n'introduisant pas de biais n'a été découvert. Cela est notamment dû au fait de l'absence d'estimateurs de Monte Carlo efficaces.  

Dans ce TER, nous nous sommes intéressés aux travaux de Cheng Zhang, Bailey Miller, Kai Yan, Ioannis Gkioulekas et Shuang Zhao (#shaung_zhao) qui proposent une solution sans biais à ce problème basée sur la séparation en deux sous-problèmes. 

Pour effectuer ce TER, nous nous sommes aussi intéressés au ray tracing ainsi qu'au path tracing, notamment grâce à la série de livres #raytracing_in_one_weekend, dans le but d'acquérir les bases nécessaires à la compréhension du papier.

Dans le cadre de ce travail, nous avons aussi implémenté un Path Tracer sur GPU avec Vulkan (#rtvk).

Nous allons introduire dans un premier temps le ray tracing ainsi que ses limites. Puis nous regarderons ce qu'est le Path Tracing  et comment il corrige les limites du Ray Tracing. Dans un troisième temps, nous parlerons du rendu différentiel et de la méthode proposée par Shuang Zhao et son équipe.
Enfin nous finirons par regarder une autre approche à ce problème avec les travaux de Tizian Zeltner, Sébastien Speierer, Iliyan Georgiev et Wenzel Jakob.

= Le Ray Tracing