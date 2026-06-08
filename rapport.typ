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

// Links
#let raytracing_in_one_weekend = link("https://raytracing.github.io/")[*Raytracing in one weekend*]
#let vk_guide = link("https://vkguide.dev/")[*VulkanGuide*]
#let shuang_zhao = link("https://projects.shuangz.com/psdr-sg20/")[*Path-Space Differentiable Rendering*]
#let ptvk(x) = link("https://github.com/CorentinVaillant/Vk-Path-Tracer")[#x]
#let suisses = link(
  "https://rgl.epfl.ch/publications/Zeltner2021MonteCarlo",
)[*Monte Carlo Estimators for Differential Light Transport*]
#let equation_rendu = link("https://fr.wikipedia.org/wiki/%C3%89quation_du_rendu")[*Page Wikipedia Equation du Rendu*]
#let metropolis = link("https://fr.wikipedia.org/wiki/Metropolis_light_transport")[*Metropolis Ligth Transport*]
#let VCM = link("https://www.iliyan.com/publications/ImplementingVCM/")[*Vertex Connection and Merging*]
#let cone = link("https://en.wikipedia.org/wiki/Cone_tracing")[*Cone Tracing*]
#let splating = link("https://fr.wikipedia.org/wiki/Gaussian_splatting")[*Gaussian Splating*]
#let Veach_equation_du_rendu_chemin = link(
  "https://graphics.stanford.edu/papers/metro/metro.pdf",
)[*Metropolis Light Transport*]
#let mecha_fluide = link("https://scispace.com/pdf/transport-relations-for-surface-integrals-arising-in-the-2up2mjqykl.pdf")[*Transport relations for surface integrals arising in the formulation of balance laws for evolving fluid interfaces*]

// Math symboles
#let ensemble_surfaces = $cal(M)$
#let espace_chemins = $Omega$
#let chemin = $#overline("x")$
#let rayon(r) = $arrow(""_dot#r)$
#let rayon_dir(r) = $arrow(""_dot#r).arrow(d)$
#let rayon_ori(r) = $arrow(""_dot#r).o$
#let mat_space = $cal(B)$
#let mouvement = $Chi$
#let trajectoire = $cal(T)$
#let extended_boundary(func,para) = $overline(partial #ensemble_surfaces)\[#func]\(#para)$

= Introduction

Le rendu différentiel est une branche de l'informatique graphique où l'on cherche à trouver
la différentielle de l'image d'un rendu d'une scène, ce qui est très utile dans de nombreux domaines.
Il possède de nombreuses applications, notamment dans le rendu plus classique, car il permet de faire varier des paramètres de la scène sans obligation de rendre la scène une nouvelle fois de zéro, ce qui peut être très couteux.
Il est aussi utile dans le rendu physiquement réaliste parce qu'il a permis de résoudre des problèmes d'analyse-par-synthèse dans des domaines comme le rendu de vêtements ou encore la création de matériaux translucides.
Son utilité ne se limite pas qu'au rendu, il possède aussi des applications dans le domaine du machine learning car il permet  d'entrainer des réseaux de neurones de manière plus efficace.
Le rendu différentiel a une communauté de recherche très active.
En effet ce domaine est très challengeant parce qu'à ce jour aucun algorithme efficace n'introduisant pas de biais n'a été découvert. Cela est notamment dû au fait de l'absence d'estimateurs de Monte Carlo efficaces.

Dans ce TER, nous nous sommes intéressés aux travaux de Cheng Zhang, Bailey Miller, Kai Yan, Ioannis Gkioulekas et Shuang Zhao (#shuang_zhao) qui proposent une solution sans biais à ce problème basée sur la séparation en deux sous-problèmes.

Pour effectuer ce TER, nous nous sommes aussi intéressés au ray tracing ainsi qu'au path tracing, notamment grâce à la série de livres #raytracing_in_one_weekend, dans le but d'acquérir les bases nécessaires à la compréhension du papier.

Dans le cadre de ce travail, nous avons aussi tenté d'implanter un Path Tracer sur GPU avec Vulkan (#ptvk[*Github vers les projet*]).

Nous allons introduire dans un premier temps le ray tracing ainsi que ses limites. Puis nous regarderons ce qu'est le Path Tracing  et comment il corrige les limites du Ray Tracing. Dans un troisième temps, nous parlerons du rendu différentiel et de la méthode proposée par Shuang Zhao et son équipe.
Enfin nous finirons par regarder une autre approche à ce problème avec les travaux de Tizian Zeltner, Sébastien Speierer, Iliyan Georgiev et Wenzel Jakob (#suisses).

= Le Rendu

== L'équation du rendu

Pour effectuer un rendu 3D, nous allons essayer de calculer la luminance des différentes surfaces de notre scène.
La luminance représente la luminosité que l'œil humain perçoit, provenant d'une surface qui émet de la lumière soit en tant que source de lumière, soit par réflexion ou transmission.
L'équation du rendu (#equation_rendu) nous permet de calculer la luminance sur les différentes surfaces de notre scène 3D.
On peut la définir comme ci-dessous :

#definition(title: "Equation du Rendu")[
  #let Lo(o, w) = $L_o\(#o,#w)$
  #let Le(o, w) = $L_e\(#o,#w)$
  #let Li(o, w) = $L_i\(#o,#w)$
  #let cosbar(x) = $overline(cos(#x))$
  #let fi(x, wo, wi) = $f_(i)(#x)$
  $
    Lo(x, omega_o) = Le(x, omega_o) + integral_Omega Li(x, omega_i) fi(x, omega_o, omega_i) cosbar(theta_i) d omega_i
  $ <équation_rendu>


  - $Lo(x, omega_o)$ représente la luminance sortante au point $x$ dans la direction $omega_o$..
  - $Le(x, omega_o)$ représente la luminance émise par le point $x$ dans la direction $omega_o$.
  - $Omega$ représente la sphère de rayon 1 autour du point $x$.
  - $Li(x, omega_i)$ représente la luminance arrivant en $x$ depuis la direction $omega_i$ et elle est définie de la manière suivante : $L_i\(x,omega_i)=L_o\(v\i\s(x,omega_i),-omega_i)$ où $v\i\s(x,omega_i)$ donne le premier point intersecté en partant dans la direction $omega_i$ a partir du point $x$.
  - $fi(x, omega_o, omega_i)$ représente la BRDF qui nous donne la distribution de la luminance arrivant en $x$ depuis la direction $omega_i$ et réfléchi dans la direction $omega_o$, il s'agit en faite d'une fonction décrivant les propriété photométrique d'une matière.
  - $theta$ représente l'angle formé $omega_i$ et la $arrow(n)$ normale de la surface.
  - $cosbar(theta)=cos(theta)$ si $cos(theta)>0$ sinon $0$.
]

L'un des problèmes de cette équation est que l'on ne peut pas résoudre l'intégrale de façon analytique, notamment en raison de sa nature récursive.
C'est pour cela que des méthodes pour estimer cette intégrale ont été mises en place.

== Par quadrature (Ray Tracing)

<raytracing_def>
#definition(title: "Rayon")[
  On appelle rayon un couple $#rayon("r")=(o, arrow(d)) in RR^3 times UU(RR^3)$ où $o$ est un point désignant l'origine du rayon et $arrow(d)$ est un vecteur unitaire désignant la direction du rayon. À noter que la direction n'est pas nécessairement unitaire, mais nous la prendrons ainsi sans perte de généralité pour des raisons de simplicité dans le reste de ce rapport.
]

Le ray tracing (lancée de rayon dans la langue de Molière) est un algorithme permettant d'estimer l'équation du rendu (@équation_rendu).
Il se base sur une techinique de lancer de rayon à partir de la caméra vers la scène, c'est-à-dire dans le sens inverse de la lumière.
Cela donne le même résultat que dans le sens de la lumière d'après le principe du retour inverse de la lumière de Fermat.
Il se base aussi sur les lois de Snell-Decartes de réflexion et réfraction de la lumière.\
Il sagit en fait d'une quadrature de la scène, à partir de rayon envoyer récursivement.
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

        If($not"intersection"$, Return($"LumièresDirectionelles".L_(e)(#rayon("r"))$))

        Comment[Recupération de la surface intersectée et de son émission]
        Assign("surface", "intersection.surface")
        Assign([$omega_o$], [$-#rayon_dir("r")$])
        Assign([$L_e$], [surface.Le($omega_o$)])
        Comment([Cas où on a atteint le nombre maximum d'itération])
        If("depth = maxDepth", Return("Le"))
        Comment([Calcul de la partie non récursive de l'intégrale de l'équation du rendu])
        Assign([bsdf], "surface.BSDF")
        Assign([$omega_i$], [$scr(U)$ ($Omega$)])
        Assign([$f_(cos)$], [bsdf($omega_o$,$omega_i$) $times$ |$omega_i dot arrow(n)$|])
        Comment([Si la partie non récursive est nulle il est inutile de continuer d'itérer])
        If([$f_(cos) = 0$], Return[$L_e$])
        Comment([Appel récursif, ($1/(4pi)$ : Probabilité de tiré une direction.)])
        // Assign([$#rayon("r")$], [CreerRayon($omega_i$)])
        Assign([$#rayon("r")$], $("intersection.point", omega_i)$) // @Julien > Qu'en pense tu ?  C'est mieux comme ça
        Return[$L_e + f_(cos) times L_i (#rayon("r"),"depth"+1) div(1 / (4 pi))$]
      },
    )
  },
)

// @Julien, pense tu cette section utiles ? Ui
Généralement, les implémentation du lancer de rayon son avec de meilleur moyen pour estimer le prochain rayon que la marche aléatoire, afin d'obtenir une meilleur convergence.

//TODO mettre comparaison

== Le Path Tracing

L'équation du rendu (@équation_rendu) peut être réécrite de façon à enlever son aspect récursif. Pour cela, au lieu d'intégrer sur la sphère unitée autour de chacun des points, nous allons effectuer un changement de variable et intégrer sur des chemins. Cette réécriture a été proposée par Veach en 1997 notamment dans son papier #Veach_equation_du_rendu_chemin.

#definition(title: "Chemin de lumière et espace des chemins")[
  Soit #ensemble_surfaces l'ensemble des surfaces des objets de notre scène.
  On appelle chemin de lumière (ou light path) un vecteur $#chemin = (x_0,x_1,...,x_N)$ de $#ensemble_surfaces^(N+1)$. Les chemins commencent sur une lumière en $x_0$ pour aller jusqu'à la caméra en $x_N$.
  On appel espace des chemins (ou path space) l'ensemble $#espace_chemins := union_(N=1)^infinity #ensemble_surfaces^(N+1)$.
]

#figure(
  image("Images/Chemin.svg", width: 50%),
  caption: [Exemple de chemin de $#ensemble_surfaces^(N+1)$],
)

En réécrivant l'équation du rendu (@équation_rendu) sur l'espace des chemins, on obtient:

#let xbar = chemin
#let dmu(x) = $d mu(#x)$
#let dmu_def = $product^(N)_(n=0) d A(x_n)$
#let We(x, y) = $W_(e)(#x -> #y)$
#let g(z, x, wn) = $g(#z : #x, #wn)$
#let g_def = $f_(s)(x_(n-1) -> x_n -> x_(n+1)) dot G(x_n, x_(n+1))$
#let f_def = $(product^(N-1)_(n=0)#g($x_(n+1)$, $x_(n-1)$, $w_n$)) dot #We($x_n$, $x_(N-1)$)$
#let G_def = $VV(x_n, x_(n+1))G_0(x_n, x_(n+1))$
#let G0_def = $(|arrow(n)_(x_n) dot omega_n| |arrow(n)_(x_(n+1)) dot (-omega_n)|)/(|| x_(n+1) - x_n ||^2)$

#let pt_eq(x) = $integral_#espace_chemins f(#x) dmu(#xbar)$

#definition(title: "Équation du rendu sur l'espace des chemins")[

  $ I = #pt_eq(xbar) $<équation_rendu_chemins>
  Où $mu$ est la mesure du produit des aires défini par $d mu(#chemin) := #dmu_def$ avec $A$ la mesure de l'aire d'une surface et $f(#chemin)$ est défini de la facon suivante :
  $ f(#chemin) = #f_def $ <f_équation_du_rendu_chemins>
  où $W_e$ est l'importance du capteur //Jsp si c'est le bon nom en français ? TODO A voir
  //@Julien *> j'aurais peut être mis sensibilité ? Peut être
  dans notre cas, $W_e$ sera une constante égale à 1 car on utilise une caméra trou d'épingle et
  $ #g($x_(n+1)$, $x_(n-1)$, $w_n$)) := #g_def $ <g_équation_du_rendu_chemins>
  où $f_s$ est la BSDF au point $x_n$ dans la direction arrivant de $x_(n-1)$ et allant vers $x_(n+1)$ si $n>0$ sinon $f_s:=L_e (x_0->x_1)$ où $L_e$ est l'émission de la surface $x_0$ dans la direction de $x_1$ et
  $ G(x_n, x_(n+1)) := #G_def $ <G_équation_du_rendu_chemins>

  où $VV (x_n, x_(n+1))$ vaut 1 si $x_n$ et $x_(n+1)$
  sont visibles, c'est-à-dire s'il n'y a pas de surfaces opaques entre eux, et 0 sinon et
  $ G_0(x_n, x_(n+1)) := #G0_def $ <G0_équation_du_rendu_chemins>
  où $omega_n$ représente le vecteur unitaire partant $x_n$ et pointant vers $x_(n+1)$.
]

Cette réécriture de l'équation du rendu sur l'espace des chemins est ce qui nous permettra dans la suite, lorsque nous aborderons les travaux de Shung Zhao et son équipe (#shuang_zhao) de calculer la différentielle de notre scène.
En effet, on verra qu'il est possible de "rentrer" la différentielle à l'intérieur de l'intégrale et que cela nous créera deux intégrales, une intérieure (ou interior) et une de bord (ou boundary).


Cette réécriture est aussi à la base de l'algorithme du path tracing qui est fondamental car nous verrons qu'il est possible de le différencier.
Il se base sur une méthode de Monte Carlo pour estimer l'intégrale sur les chemins (@équation_rendu_chemins).


//TODO à verifier et à commenter
#let r = rayon("r")
#let r_dir = rayon_dir("r")
#let r_ori = rayon_ori("r")
#let wo = $omega_o$
#let wi = $omega_i$
#let x0 = $x_0$
#let x1 = $x_1$
#let x2 = $x_2$
#let alpha = $alpha$
#let beta = $beta$
#let epsilon = $epsilon$
#let p0 = $p_0$
#let alphadirect = $alpha_("directe")$
#let alphaindirect = $alpha_("indirecte")$
#let normalize(v) = $#v/(|#v|)$
#let n(x) = $scr(n)(#x)$
<pathtracer_def>
#algorithm-figure(
  "Path Tracer",
  vstroke: .5pt + luma(200),
  {
    import algorithmic: *
    Procedure(
      [$L_i$],
      [Rayon $#r$],
      {
        Assign(wo, $#r_dir$)
        Assign(x1, $#r_ori$)
        Assign("intersection", $"Intersection"(#r)$)
        If($not"intersection"$, Return($"LumièresDirectionelles".L_(e)(#r)$))

        Assign(x2, $"intersection"."point"$)

        Assign($L$, $"intersection".L_(e)(wo)$)
        Assign(beta, $1$)

        Comment([$epsilon > 0 "fixé."$])
        While($beta>epsilon$, {
          Comment([Éclairage direct (échantillonage de la lumière)])
          Assign(p0, $p ~ PP_("lumières")$)
          LineComment(Assign(wi, $normalize(p0-x2)$))[direction de $x2$ vers $p0$]

          Assign(alphadirect, $p0. L_e (p0 -> x_1) f_s (p0 -> x1 -> x2) G(p0,x1)$)
          Assign($L$, $L + T dot alphadirect \/ PP_("lumières")(p_0)$)

          LineBreak
          Assign(wi, $omega ~ PP_("bsdf")$)
          Comment([$(x1,wi)$ : le rayon partant de $x1$ avec la direction $wi$])
          Assign("intersection", $"Intersection"((x1,wi))$)
          If($not"intersection"$, Break)
          Assign(alphaindirect, $f_s (x0 -> x1 -> x2) G(x0,x1)$)
          Comment([On convertie la probabilité en mesure d'aire :]) //TODO détailler mesure angle / aire
          Assign($q$, $PP_("bsdf")(wi) (|#n(x0) dot -wi |) / (|| x0 - x1||^2)$) //TODO definir #n
          Assign($T$, $T alphaindirect \/q$)

          LineBreak

          Comment([On continue le chemin.])
          Assign($(x2,x1)$, $(x1, x0)$)
          Assign(r, $(x1->x2)$)
        })

        Return($L$)
      },
    )
  },
)

== Autres Méthodes

De nombreuses autres méthodes existent pour résoudre l'équation du rendu et ont chacune leurs avantages mais aussi leurs inconvénients. Parmi celles-ci, on retrouve :


+ #block[La rastérisation qui, comme le ray tracing, est une quadrature de l'équation du rendu.
    Elle est non biaisée et différenciable mais elle reste très limitée, notamment au niveau de la différenciation et à une convergence assez lente. //TODO expliquer le principe
  ]

+ #block[Le photon mapping qui se base aussi sur une technique de lancer de rayon.
    Contrairement au ray tracing et au path tracing, les rayons sont envoyés depuis les lumières et on enregistre leurs chemins dans une photon map.
    Puis pour effectuer le rendu, on va envoyer un rayon depuis la caméra et à son point d'intersection avec une surface, regarder la concentration de points à proximité sur la photon map avec un algorithme des plus proches voisins.
    Cet algorithme est biaisé, donc il n'a pas vraiment d'intérêt à être différencié, mais il joue un rôle dans la méthode proposée par Shuang Zhao et son équipe (#shuang_zhao), nous en reparlerons dans la section dédiée.]

+ #block[Le bidirectional path tracing est une version améliorée du path tracing. Au lieu de créer des chemins uniquement depuis la caméra, il va aussi créer des chemins partant des lumières et les connecter entre eux avec un rayon de visibilité.
    De plus cet algorithme est non biaisé mais, malheureusement, à ce jour aucune technique de différentiation n'a été découverte.]

+ #block[Bien d'autres méthodes existent comme le #metropolis qui se base sur l'algorithme de Metropolis-Hastings, le #VCM qui fusionne le bidirectional path tracing et le photon mapping, le #cone qui donne une épaisseur aux rayons, ce que ne fait pas le raytracing ou encore le #splating qui effectue le rendu à l'aide de données extraites d'image et beaucoup d'autres… //On peut en rajouter si on en trouve des sympas :)
  ]
= La Différentiation

== La Méthode Naïve

Pour obtenir une aproximation, nous pourrions utilisé la méthode la différence fini.

Pour toute fonction continue $f$, le théorème de Taylor nous donne pour $V$ un voisinage de $x_0$:

$h : x_0 + h in V$ \
$f(x_0 + h) = sum_(n in NN) (f^((n)) (x_0))/(n!) h^n$ \
$= f(x_0) + f'(x_0)h + R(x_0 + h)$ : Avec $R(x_0 + h)$ le reste.\
$<=> f(x_0 + h) / h = f(x_0)/h + f'(x_0) + R(x_0 + h)/h$ \
$<=> f'(x_0) = ( f(x_0 + h) - f(x_0)) /h - R(x_0 + h)/h$ \
En assumant $R(x_0 + h)$ suffisament petit, nous avons donc :\
$f'(x_0) tilde.eq ( f(x_0 + h) - f(x_0)) /h$

Nous pouvons donc appliqué cette méthodes, en utilisant $h$ assez petit.\
Ici $pi in RR$ représentes un paramètre de la scène. On notera toutes les fonctions dépendant de la scène à l'aide de la syntaxe suivantes $phi(pi : x_1, ... x_k)$, où $phi$ est une fonction quelconque dépendant des paramètres de la scène. \
Nous avons donc :

$partial/(partial pi) #pt_eq($pi: #xbar$) tilde.eq (#pt_eq($pi: #xbar$) - #pt_eq($pi - h: #xbar$)) / h$

La méthode est donc facile à comprendre et à implanter, mais elle soufre de deux gros inconvénients.
Premièrement, la stabilité numérique des nombre à virgule flotantes, en effet, s'il on prend $h$ trop petit, les imprécisions dans le calcul deviendrons de plus en plus importante.

Et de plus, cette méthode nécessite de faire deux rendues,ce qui provoque donc le doublage du temps de calcul.

== La Méthode Etudiée (Méthode de l'UC)

#let x_hat = $bold(hat(x))$
#let x_hat_def = [
  Pour une trajectoire $cal(T)$ nous pouvons définire un paramètrisation local, proche de $(x, pi) in cal(T)$.
  On fixe $hat(x)(xi, pi')$, qui pour un ouvert $cal(O) in RR^2$ :
  - $#x_hat (cal(O), pi) subset #ensemble_surfaces (pi)$
  - $forall pi'$ proche de $pi$ : $#x_hat (dot, pi')$ est $cal(C)^1$ et injectif.
  - $forall xi in cal(O) : #x_hat (xi, dot)$ est $cal(C)^1$ sur un voisinage de $pi$.
]

#let vel_loc = $v$
#let vel_scal = $V$
#let vel_tan = $#vel_loc _("tan")$
#let norm_field = $scr(cal(n))$

#let vel_def = [
  Avec $x in cal(M)(pi)$ et la paramètrisation #x_hat, il existe un unique $xi in cal(O)$ qui satisfait $#x_hat (xi, pi) = x$.
  On note $xi$ comme étant les coordonées local de $x$.\
  On peut donc définir la vitesse local de $x$ comme :

  #figure($#vel_loc (x, pi) = (partial #x_hat (xi, pi'))/(partial pi') |_(pi' = pi)$)

  Et donc en utilisant $cal(M)(pi)$ orienté par un champs de vecteur normaux $#norm_field (x, pi)$, on défini $#vel_scal = #vel_loc dot #norm_field$ et
  $#vel_tan = #vel_loc - #vel_scal #norm_field$, respectivement, la vitesse scalaire local et la vitesse tangentielle local.

]

Avant de commencer à aborder la méthode de Shuang Zhao et son équipe (#shuang_zhao) nous allons d'abord introduire quelques définitions importantes.

//TODO : à retaper jsp c'est pas ouf j'ai l'impression tu en penses quoi @Corentin ?

#definition(title: "Configuration de référence, mouvement et déformation")[
  Soit #mat_space un manifold 2D abstrait que l'on nommera configuration de référence. 
  On appelle une déformation de #mat_space une fonction injective différentiable de #mat_space sur une surface #ensemble_surfaces.
  On appelle #mouvement un mouvement de #mat_space une fonction $cal(C)^3$ de $#mat_space times RR$ dans #ensemble_surfaces. 
  De plus nous pouvons remarquer que si on fixe un paramètre $pi in RR$, alors $#mouvement\(dot,pi)$ est une déformation de #mat_space.
]
 
#definition(title : "Surface évoluante, carte de référence et trajectoire")[
  Pour un mouvement #mouvement et un paramètre $pi$, on appelle surface évoluante l'image $#ensemble_surfaces\(pi) := {#mouvement\(p,pi) : p in #mat_space} in RR^3$ de la fonction $#mouvement\(p,pi)$.
  De plus, comme cette fonction est injective, on peut définir une fonction inverse sur son image $P(dot,pi) : #ensemble_surfaces\(pi) -> #mat_space$ que l'on appellera carte de référence.
  Enfin on appellera trajectoire l'ensemble $#trajectoire$ des couples $(x,pi) in  #ensemble_surfaces\(pi) times RR$ des surfaces évoluantes et de leur paramètre $pi$ associé.
]

#definition(title : "Espace des matériaux et espace des position")[
  On appellera $p in #mat_space$ un point de matériau et $x in #ensemble_surfaces\(pi)$ un point de position.
  Nous pouvons aussi remarquer que la déformation $#mouvement\(dot,pi)$ établit une bijection entre les points de matériau et les points de position.
  On appellera champ de matériau une fonction de $#mat_space times RR$ et champ de position une fonction sur la trajectoire $#trajectoire$.
]
Pour les définitions nous allons poser $phi\(x,pi)$ un champ de position scalaire sur $#ensemble_surfaces\(pi)$.

#definition(title : "Derivée de scène")[
  $phi$ admet une dérivée de scène de la forme :
  $ dot(phi)\(x,pi) = partial / (partial pi') phi(hat(x)\(xi,pi'),pi') |_(pi'=pi) $ <derivée_scene>
  Elle admet aussi une forme normalisée de cette dérivée :
  $ phi^square = dot(phi) - v_tan dot "grad"_#ensemble_surfaces (phi) $ <derivée_scene>
]

#definition(title : "Courbes de discontinuité et bordure étendue")[
  La foction $phi$ est $cal(C)^0$ en fonction de $x$ sauf sur un ensemble de courbes qui évolue de façon continue en fonction de $pi$. On pose $Delta#ensemble_surfaces\[phi]\(pi) subset #ensemble_surfaces\(pi)$ l'ensemble des ces courbes de discontinuité. On appellera #extended_boundary($phi$,$pi$) la bordure étendue l'ensemble des bordures de $#ensemble_surfaces\(pi)$ et des courbes de discontinuité. 
]

En utilisant la relation de transport venant de la mécanique des fluides par _Cermelli_ (#mecha_fluide) on peut obtenir :

$ d / (d pi) integral_#ensemble_surfaces phi d A = I_"intérieur" + I_"bordure" $ <int_interieur_et_bordure>
Avec $ I_"intérieur" = integral_#ensemble_surfaces (phi^square - phi kappa V)d A $
$ I_"bordure"= integral_overline(partial #ensemble_surfaces) Delta phi V_overline(partial #ensemble_surfaces)d A $
Avec $kappa$ la courbature totale, $V$ et $V_overline(partial #ensemble_surfaces)$ les vistesses normales scalaires de $#ensemble_surfaces\(pi)$ et de la bordure étendue et $Delta phi(x,pi)$ le prolongement défini comme si dessous :
$ Delta phi(x,pi) := cases(
  phi(x,pi) "si" x in partial#ensemble_surfaces\(pi\),
  phi^-(x,pi) - phi^+(x,pi) "si" x in Delta#ensemble_surfaces\(pi\)
)
 $ 



== Autres Méthodes (Methode de l'EPFL)

// implantation
= Implantation des algorithme

Afin de pouvoir comprendre les algorithmes étudiés, nous avons implémenté un ray tracer et un path tracer.

== Premier ray tracer

Nous avons donc commencé par suivre une série de tutoriels : #raytracing_in_one_weekend, écrit principalement par _Peter Shirley_.\
Le but de ces tutoriels était d'implanter, en `C++`, un premier ray tracer.


Cela nous à permis de comprendre le ray tracing de façon concrète, nous avons écrit plusieurs abstractions (formes, matériaux, textures, caméra, _ect_..), qui nous ont ensuite permis d'appliquer les mathématiques de l'algorithme.

Cette première implantation souffrait de la faible parallélisation du `CPU`. En effet, les temps de rendu pouvaient être très longs.

#let rtowe_caption = "Scène rendue à partir du ray tracer implanté, le temps de rendu est d'environ 3 minutes (CPU $3.5 GHz$)."
#let rtowe = image("Images/Rt_series/rtowe.png", width: 100%, alt: rtowe_caption)

#figure(rtowe, caption: rtowe_caption)

== Autres implantation `CPU`

La suite des tutoriels de _Peter Shirley_ nous a amenés à construire des rendus plus élaborés.
Nous avons donc ajouté la possibilité d'avoir des matériaux volumétriques et des textures.

*TODO IMG VOLUMÉTRIQUE && textures*

Afin d'accélérer le processus, nous avons implanté divers moyens d'accélérer le processus, comme des `BVH` (Bounding Volume Hierarchy, comprendre hiérarchie des volumes englobants), et des méthodes de Monte Carlo plus efficaces, par exemple, au lieu d'opérer la quadrature sur une marche aléatoire à direction uniforme, nous tirons une direction en fonction de la distribution de la `BRDF`.

Au fur et à mesure, le tutoriel nous amène à construire un path tracer, les nouvelles directions sont donc tirées en fonction du placement des lumières, et l'on passe d'un programme récursif à terminal-récursif.

De plus, nous avons ajouté quelques fonctionnalités supplémentaires, telles que le chargement de maillage et le multi-threading.
*TODO add mesh*

== Passage sur GPU

Pour la suite nous avons décidé d'utiliser `Vulkan` pour une implantation sur `GPU`.
`Vulkan` est une spécification proposée par _Khronos Group_ (qui propose aussi `OpenGL`), qui a vocation à remplacer `OpenGL`.
`Vulkan` nous permet d'avoir un grand contrôle sur la carte graphique, mais comme le dit l'adage : "Un grand pouvoir implique de grandes responsabilités", la spécification est donc dure à prendre en main, avec un débogage compliqué, et une quantité de code à écrire conséquente.\
Afin de nous aider, nous avons encore une fois suivi ce tutoriel : #vk_guide, qui nous a permis d'implanter un simple moteur graphique de rasterization.\
Beaucoup d'abstractions utilisées dans le tutoriel ont été réutilisées par la suite.

Une fois `Vulkan` appréhendé, nous avons fait notre premier ray tracer sur `GPU`, bien que rudimentaire, ce dernier était beaucoup plus rapide que les implantations sur `CPU`.

#let gpu_raytrace_img_caption = "Scène rendue à partir du ray tracer fait sur `Vulkan`, rendu en temps réel (carte graphique intégrée sur un CPU)."
#let gpu_raytrace_img = image(
  "Images/Vulkan/first rt.png",
  width: 50%,
  alt: "Deux balles, on peut voir une réflexion très prononcée sur les objets.",
)

#figure(
  gpu_raytrace_img,
  caption: gpu_raytrace_img_caption,
)

De plus, nous avons utilisé le langage de shader #link("https://shader-slang.org/")[*Slang*], un langage de shader qui nous permet d'exécuter du code directement sur la carte graphique. Nous avons choisi ce langage car l'auto-différentiation y est implanté.

Malheureusement, le temps nous a manqué, l'implantation du ray tracer sur `Vulkan` a pris plus de temps que prévu, et la complexité des mathématiques utilisées dans l'algorithme du path tracer nous a ralentis. Le path tracer que nous voulions implémenter n'a donc pas pu être fini à temps.\
Nous avons donc décidé qu'après le rendu de ce rapport, nous finaliserons l'implantation, pour à terme, y inclure les travaux de _Shuang Zhao_.

Le code pourra être trouvé sur le repo Github #ptvk[*Vulkan Path Tracer*].

= Conclusion

= Annexe

== Bibliographie
