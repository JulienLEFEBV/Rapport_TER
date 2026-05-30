#import "@preview/latexlike-report:1.0.0": *

#import "@preview/algorithmic:1.0.7" 
#import algorithmic: algorithm-figure, style-algorithm
#show: style-algorithm




#import "@preview/great-theorems:0.1.2": *
#import "@preview/rich-counters:0.2.1": *

#set heading(numbering: "1.1")
#show: great-theorems-init

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

  logo: image("Images/LogoFSI.png"),

  //==========Theme ===============
  theme-color: rgb("#000000"),
  lang: "fr",
  participants-supplement: "Auteurs:", //Change it if you change the language


  //=========Font =================
  title-font: "New Computer Modern",
  font: "New Computer Modern",
  font-size: 13pt,
  font-weight: 400,

  //============ Math =============

  math-font: "New Computer Modern Math",
  math-weight: 400,
  math-ref-supplement: auto, //Use none for no supplement, auto for language based or any other function or string you like
  math-numbering: "(1.1)", // The numbering style you like

  // ---- Equate package ---
  // For more information, you can refer to equate documentation

  math-number-mode: "label", //Can be "label" or "line"
  math-sub-numbering: true, // true or false

  //===========Page style===============
  pagebreak-section: true, //For pagebreak after adding a new level one heading (=)
  show-outline: true, //true or false
  page-paper: "a4",

  //-----chic header package----
  // customize the left/center/right header and left/center/right footer
  // you can add images, text, the number of the current page, etc, or put none if you don't want some part of the header or footer.
  //some usefull function: chic-page-number(), chic-heading-name()

  h-l: [#smallcaps[Rapport TER]],
  h-r: [#image("Images/PetitLogoFSI.png", width: 14%)],
  h-c: none,

  f-l: [],
  f-r: [],
  f-c: chic-page-number(),
  //=======================================
  //For more customitation you can check the documentation. !! Enjoy :D !!
)

#set math.equation(numbering: "(1)", supplement: [éq.])
#let no-num(content) = {
  math.equation(
    block: true,
    numbering: none,
    content,
  )
}


#let mathcounter = rich-counter(
  identifier: "mathblocks",
  inherited_levels: 1,
)
#let theorem = mathblock(
  blocktitle: "Théorème",
  counter: mathcounter,
)
#let definition = mathblock(
  blocktitle: "Définition",
  counter: mathcounter,
)


#let raytracing_in_one_weekend = link("https://raytracing.github.io/")[*Raytracing in one weekend*]
#let shaung_zhao = link("https://projects.shuangz.com/psdr-sg20/")[*Path-Space Differentiable Rendering*]
#let rtvk = link("https://github.com/CorentinVaillant/RtVk")[*GitHub du projet*]
#let suisses = link(
  "https://rgl.epfl.ch/publications/Zeltner2021MonteCarlo",
)[*Monte Carlo Estimators for Differential Light Transport*]
#let equation_rendu = link("https://fr.wikipedia.org/wiki/%C3%89quation_du_rendu")[*Page Wikipedia Equation du Rendu*]
#let metropolis = link("https://fr.wikipedia.org/wiki/Metropolis_light_transport")[*Metropolis Ligth Transport*]
#let VCM = link("https://www.iliyan.com/publications/ImplementingVCM/")[*Vertex Connection and Merging*]
#let cone = link("https://en.wikipedia.org/wiki/Cone_tracing")[*Cone Tracing*]
#let splating = link("https://fr.wikipedia.org/wiki/Gaussian_splatting")[*Gaussian Splating*]
#let Veach_equation_du_rendu_chemin = link("https://graphics.stanford.edu/papers/metro/metro.pdf")[*Metropolis Light Transport*]

#let ensemble_surfaces = $cal(M)$
#let espace_chemins = $Omega$
#let chemin = $#overline("x")$
#let rayon(r)= $.arrow(#r)$

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
Enfin nous finirons par regarder une autre approche à ce problème avec les travaux de Tizian Zeltner, Sébastien Speierer, Iliyan Georgiev et Wenzel Jakob (#suisses).

= Le Rendu

== L'équation du rendu

Pour effectuer un rendu 3D, nous allons essayer de calculer la luminance des différentes surfaces de notre scène.
La luminance représente la luminosité que l'œil humain perçoit, provenant d'une surface qui émet de la lumière soit en tant que source de lumière, soit par réflexion ou transmission.
L'équation du rendu (#equation_rendu) nous permet de calculer la luminance sur les différentes surfaces de notre scène 3D.
On peut la définir comme ci-dessous :

#definition(title: "Equation du Rendu")[
  $
    L_o\(x,omega_o) = L_e\(x,omega_o) + integral_Omega L_i\(x,omega_i) f_i\(x,omega_0,omega_i) #overline[cos]\(theta_i) d omega_i
  $ <équation_rendu>

  - $L_o\(x,omega_o)$ représente la luminance sortante au point $x$ dans la direction $omega_o$.
  - $L_e\(x,omega_o)$ représente la luminance émise par le point $x$ dans la direction $omega_o$.
  - $Omega$ représente la sphère de rayon 1 autour du point $x$.
  - $L_i\(x,omega_i)$ représente la luminance arrivant en $x$ depuis la direction $omega_i$ et elle est définie de la manière suivante : $L_i\(x,omega_i)=L_o\(v\i\s(x,omega_i),-omega_i)$ où $v\i\s(x,omega_i)$ donne le premier point intersecté en partant dans la direction $omega_i$ a partir du point $x$.
  - $f_i\(x,omega_0,omega_i)$ représente la BRDF qui indique comment la luminance arrivant en $x$ depuis la direction $omega_i$ et réfléchi dans la direction $omega_o$.
  - $theta$ représente l'angle formé $omega_i$ et la $arrow(n)$ normale de la surface.
  - $#overline[cos]\(theta)=cos(theta)$ si $cos(theta)>0$ sinon $0$.
]

L'un des problèmes de cette équation est que l'on ne peut pas résoudre l'intégrale de façon analytique, notamment en raison de sa nature récursive.
C'est pour cela que des méthodes pour estimer cette intégrale ont été mises en place.

== Le Ray Tracing

#definition(title : "Rayon")[
  On appelle rayon un couple $#rayon("r")=(o, arrow(d)) in  RR^3 times UU(RR^3)$ où $o$ est un point désignant l'origine du rayon et $arrow(d)$ est un vecteur unitaire désignant la direction du rayon. À noter que la direction n'est pas nécessairement unitaire, mais nous la prendrons ainsi sans perte de généralité pour des raisons de simplicité dans le reste de ce rapport.
]

Le ray tracing (lancée de rayon dans la langue de Molière) est un algorithme permettant d'estimer l'équation du rendu (@équation_rendu).
Il se base sur une techinique de lancer de rayon à partir de la caméra vers la scène, c'est-à-dire dans le sens inverse de la lumière.
Cela donne le même résultat que dans le sens de la lumière d'après le principe du retour inverse de la lumière de Fermat.
Il se base aussi sur les lois de Snell-Decartes de réflexion et réfraction de la lumière.
Une méthode de ray tracing naïve de la marche aléatoire :
#algorithm-figure(
  "Marche Aléatoire",
  vstroke: .5pt + luma(200),
  {
    import algorithmic: *

    Procedure(
      [$L_i$],
      ([Rayon $#rayon("r")$], [depth $in NN$]),
      {
        Assign("intersection", [Intersection($#rayon("r")$)])
        Comment[Cas où le rayon n'intersecte aucune surface]
        If("Pas d'intersection", {
          Assign([$L_e$], "0")
          For([lumière $in$ Lumières Directionelles], Assign([$L_e$], [$L_e$ + lumière.$L_e\(#rayon("r"))$]))
          Return[$L_e$]
        })
        Comment[Recupération de la surface intersectée et de son émission]
        Assign("surface", "intersection.surface")
        Assign([$omega_o$], [$-#rayon("r")$.direction])
        Assign([$L_e$], [surface.Le($omega_o$)])
        Comment([Cas où on a atteint le nombre maximum d'itération])
        If("depth = maxDepth", Return("Le"))
        Comment([Calcul de la partie non récursive de l'intégrale de l'équation du rendu])
        Assign([bsdf], "surface.BSDF")
        Assign([$omega_i$], [$scr(U)$ ($Omega$)])
        Assign([$f_(cos)$], [bsdf($omega_o$,$omega_i$) $times$ |$omega_i dot arrow(n)$|])
        Comment([Si la partie non récursive est nulle il est inutile de continuer d'itérer])
        If([$f_(cos) = 0$], Return[$L_e$])
        Comment([Appel récursif])
        Assign([$#rayon("r")$], [CreerRayon($omega_i$)])
        Return[$L_e$ + fcos $times$ $L_i$($#rayon("r")$,depth+1) / (1 / (4 $times$ $pi$))]
      },
    )
  },
)

//TODO parler du fait que c'est une quadrature

== Le Path Tracing

L'équation du rendu (@équation_rendu) peut être réécrite de façon à enlever son aspect récursif. Pour cela, au lieu d'intégrer sur la sphère unitée autour de chacun des points, nous allons effectuer un changement de variable et intégrer sur des chemins. Cette réécriture a été proposée par Veach en 1997 notamment dans son papier #Veach_equation_du_rendu_chemin.

#definition(title: "Chemin de lumière et espace des chemins")[
  Soit #ensemble_surfaces l'ensemble des surfaces des objets de notre scène. 
  On appelle chemin de lumière (ou light path) un vecteur $#chemin = (x_0,x_1,...,x_N)$ de $#ensemble_surfaces^(N+1)$. Les chemins commencent sur une lumière en $x_0$ pour aller jusqu'à la caméra en $x_N$. 
  On appel espace des chemins (ou path space) l'ensemble $#espace_chemins := union_(N=1)^infinity #ensemble_surfaces^(N+1)$.
]

#figure(
  image("Images/Chemin.jpg", width: 50%),
  caption:[Exemple de chemin de $#ensemble_surfaces^(N+1)$],
)

En réécrivant l'équation du rendu (@équation_rendu) sur l'espace des chemins, on obtient:

#definition(title: "Équation du rendu sur l'espace des chemins")[
  $ I = integral_#espace_chemins f(#chemin) d mu(#chemin) $ <équation_rendu_chemins>
  Où $mu$ est la mesure du produit des aires défini par $d mu(#chemin) := Pi^N_(n=0) d A(x_n)$ avec $A$ la mesure de l'aire d'une surface et $f(#chemin)$ est défini de la facon suivante :
  $ f(#chemin) = (Pi^(N-1)_(n=0)g(x_(n+1):x_(n-1),w_n)) W_e (x_N -> x_(N-1)) $ <f_équation_du_rendu_chemins>
  où $W_e$ est l'importance du capteur //Jsp si c'est le bon nom en français ? TODO A voir
  dans notre cas, $W_e$ sera une constante égale à 1 car on utilise une caméra trou d'épingle et
  $ g(x_(n+1):x_(n-1),w_n)) := f_s (x_(n-1)->x_n->x_n+1) G(x_n <-> x_(n+1)) $ <g_équation_du_rendu_chemins>
  où $f_s$ est la BSDF au point $x_n$ dans la direction arrivant de $x_(n-1)$ et allant vers $x_(n+1)$ si $n>0$ sinon $f_s:=L_e (x_0->x_1)$ où $L_e$ est l'émission de la surface $x_0$ dans la direction de $x_1$ et
  $ G(x_n <-> x_(n+1)) := VV (x_n <-> x_(n+1)) G_0(x_n <-> x_(n+1)) $
  <G_équation_du_rendu_chemins>
  où $VV (x_n <-> x_(n+1))$ vaut 1 si $x_n$ et $x_(n+1)$ sont visibles, c'est-à-dire s'il n'y a pas de surfaces opaques entre eux, et 0 sinon et $ G_0 := frac(|arrow(n)_(x_n) dot omega_n| |arrow(n)_(x_(n+1)) dot (-omega_n)|, ||x_(n+1)-x_n||²) $ <G0_équation_du_rendu_chemins>
  où $omega_n$ représente le vecteur unitaire partant $x_n$ et pointant vers $x_(n+1)$.
]

Cette réécriture de l'équation du rendu sur l'espace des chemins est ce qui nous permettra dans la suite, lorsque nous aborderons les travaux de Shung Zhao et son équipe (#shaung_zhao) de calculer la différentielle de notre scène.
En effet, on verra qu'il est possible de "rentrer" la différentielle à l'intérieur de l'intégrale et que cela nous créera deux intégrales, une intérieure (ou interior) et une de bord (ou boundary).


Cette réécriture est aussi à la base de l'algorithme du path tracing qui est fondamental car nous verrons qu'il est possible de le différencier.
Il se base sur une méthode de Monte Carlo pour estimer l'intégrale sur les chemins (@équation_rendu_chemins).


//TODO à verifier et à commenter
#algorithm-figure(
  "Path Tracer",
  vstroke: .5pt + luma(200),
  {
    import algorithmic: *
     Procedure(
      [$L_i$],
      ([Rayon $#rayon("r")$]),
       {
        Assign("L",[0])
        Assign($beta$,[1])
        Assign([specularBounce],[vrai])
        Assign("depth",[0])
        While([$beta$ non nul],
        {
          Assign([intersection],[Intersection($#rayon("r")$)])
          If([Pas d'intersection],
            If([specularBounce],{
              For([lumière $in$ Lumières Directionelles],Assign([$L$],[$L$+lumière.$L_e\(#rayon("r"))$]))
             Break
          }))
          Assign([surface],"intersection.surface")
          If("specularBounce",Assign($L$,[$L$+surface.$L_e\(-#rayon("r")."direction")$]))
          If([depth = maxDepth],Break)
          Assign("bsdf",[surface.BSDF($#rayon("r")$)])
          If([bsdf = 0],{
            [passerItersection($#rayon("r")$,intersection.tTouche) #linebreak()]
            [Continuer]
          })
          Assign([$omega_o$],[$#rayon("r")$])
          Assign("lumière",[ChoisirUneLumiereAléatoirement()]) //c'est vraiment ça ? je suis pas trop sur de moi :p
          If([lumière != 0],{
            Assign([pointLumière],"lumière.ChoisirPointAléatoirement()")
            Assign([ls],[lumière.echantilloner$L_i$(intersection,pointLumière)])
            If([ls != 0 et ls.pdf >0],{
              Assign([$omega_i$],[ls.$omega_i$])
              Assign([$f_(cos)$], [bsdf.f($omega_o$,$omega_i$) $times$ |$omega_i dot arrow(n)$|])
              If([f != 0 et Visible(intersection,ls.pLumière)], Assign($L$,[$L$ + $beta times f_cos times "ls".L$/(lumière.p $times$ ls.pdf)]) )
            })
          })
          Assign([bs],[bsdf.echantilloner($omega_o$)]) //pas sûr sûr :p
          If([bs = 0], Break)
          Assign([$beta$],[$beta times "bs".f times |omega_i dot arrow(n)|$ / bs.pdf])
          Assign([specularBounce],[bs.estSpeculaire])
          Assign([$#rayon("r")$],[CreerRayon(bs.$omega_i$)])
        })
        Return[$L$]
      },
    )
  },
)

//TODO Ajouter algo
== Autres Méthodes

De nombreuses autres méthodes existent pour résoudre l'équation du rendu et ont chacune leurs avantages mais aussi leurs inconvénients. Parmi celles-ci, on retrouve :


+ #block[La rastérisation qui, comme le ray tracing, est une quadrature de l'équation du rendu.
    Elle est non biaisée et différenciable mais elle reste très limitée, notamment au niveau de la différenciation et à une convergence assez lente. //TODO expliquer le principe
  ]

+ #block[Le photon mapping qui se base aussi sur une technique de lancer de rayon.
    Contrairement au ray tracing et au path tracing, les rayons sont envoyés depuis les lumières et on enregistre leurs chemins dans une photon map.
    Puis pour effectuer le rendu, on va envoyer un rayon depuis la caméra et à son point d'intersection avec une surface, regarder la concentration de points à proximité sur la photon map avec un algorithme des plus proches voisins.
    Cet algorithme est biaisé, donc il n'a pas vraiment d'intérêt à être différencié, mais il joue un rôle dans la méthode proposée par Shuang Zhao et son équipe (#shaung_zhao), nous en reparlerons dans la section dédiée.]

+ #block[Le bidirectional path tracing est une version améliorée du path tracing. Au lieu de créer des chemins uniquement depuis la caméra, il va aussi créer des chemins partant des lumières et les connecter entre eux avec un rayon de visibilité.
    De plus cet algorithme est non biaisé mais, malheureusement, à ce jour aucune technique de différentiation n'a été découverte.]

+ #block[Bien d'autres méthodes existent comme le #metropolis qui se base sur l'algorithme de Metropolis-Hastings, le #VCM qui fusionne le bidirectional path tracing et le photon mapping, le #cone qui donne une épaisseur aux rayons, ce que ne fait pas le raytracing ou encore le #splating qui effectue le rendu à l'aide de données extraites d'image et beaucoup d'autres… //On peut en rajouter si on en trouve des sympas :)
  ]
= La Différentiation

== La Méthode Naïve

== La Méthode Etudiée (Méthode de l'UC)

== Autres Méthodes (Methode de l'EPFL)

= Implementation du Path Tracer

= Difficultées Rencontrées

= Conclusion

= Bibliographie
