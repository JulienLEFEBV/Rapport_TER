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

#set math.equation(numbering: "(1)", supplement: [éq.])
#let no-num(content) = {
  math.equation(
    block: true, 
    numbering: none, 
    content
  )
}


#let raytracing_in_one_weekend = link("https://raytracing.github.io/")[*Raytracing in one weekend*]
#let shaung_zhao = link("https://projects.shuangz.com/psdr-sg20/")[*Path-Space Differentiable Rendering*]
#let rtvk = link("https://github.com/CorentinVaillant/RtVk")[*GitHub du projet*]
#let suisses = link("https://rgl.epfl.ch/publications/Zeltner2021MonteCarlo")[*Monte Carlo Estimators for Differential Light Transport*]
#let papier_equation_rendu = link("https://dl.acm.org/doi/10.1145/15886.15902")[*The rendering equation*]


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

== L'équation du rendu

Pour effectuer un rendu 3D, nous allons essayer de calculer la luminance des différentes surfaces de notre scène.
La luminance représente la luminosité que l'œil humain perçoit, provenant d'une surface qui émet de la lumière soit en tant que source de lumière, soit par réflexion ou transmission. 
L'équation du rendu (#papier_equation_rendu) nous permet de calculer la luminance sur les différentes surfaces de notre scène 3D.
On peut la définir comme ci-dessous :

$ L_o\(x,omega_o) = L_e\(x,omega_o) + integral_Omega L_i\(x,omega_i) f_i\(x,omega_0,omega_i) #overline[cos]\(theta_i) d omega_i $ <équation_rendu>

- $L_o\(x,omega_o)$ représente la luminance sortante au point $x$ dans la direction $omega_o$.
- $L_e\(x,omega_o)$ représente la luminance émise par le point $x$ dans la direction $omega_o$.
- $Omega$ représente la sphère de rayon 1 autour du point $x$.
- $L_i\(x,omega_i)$ représente la luminance arrivant en $x$ depuis la direction $omega_i$ et elle est définie de la manière suivante : $L_i\(x,omega_i)=L_o\(v\i\s(x,omega_i),-omega_i)$ où $v\i\s(x,omega_i)$ donne le premier point intersecté en partant dans la direction $omega_i$ a partir du point $x$.
- $f_i\(x,omega_0,omega_i)$ représente la BRDF qui indique comment la luminance arrivant en $x$ depuis la direction $omega_i$ et réfléchi dans la direction $omega_o$.
- $theta$ représente l'angle formé $omega_i$ et la normale de la surface.
- $#overline[cos]\(theta)=cos(theta)$ si $cos(theta)>0$ sinon $0$.

L'un des problèmes de cette équation est que l'on ne peut pas résoudre l'intégrale de façon analytique, notamment en raison de sa nature récursive.
C'est pour cela que des méthodes pour estimer cette intégrale ont été mises en place.

