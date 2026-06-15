#import "@preview/latexlike-report:1.0.0": *

#import "@preview/algorithmic:1.0.7"
#import algorithmic: algorithm-figure, style-algorithm
#show: style-algorithm


#import "@preview/great-theorems:0.1.2": *
#import "@preview/rich-counters:0.2.1": *

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
  font-size: 10.5pt,
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
  // @JulienLEFEBV > on peut le passer à false, moins lisible mais on gagne pas mal de pages
  pagebreak-section: false, //For pagebreak after adding a new level one heading (=)
  show-outline: false, //true or false
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

// Remerciements
= Remerciements <nonumber>
#set heading(numbering: none)

Nous tenions à remercier les professeurs nous ayant accompagnés lors de notre parcours, ainsi que notre encadrant pour le ce `TER`, Mathias Paulin, Mathieu Sablik, Millan Poquet et Armelle Bonenfant.

Ainsi que les deux relecteurs externes au projet, qui nous ont permis d'obtenir une meilleure rédaction, Thomas Saurel, Eiden Anger.

Et de plus nous aimerions remercier les membres de nos familles, sans qui cela n'aurait pas été possible : Cyril et Aline Lefebvre, Nathalie Chevalier  et Mathieu Vaillant.

#pagebreak()
#set heading(numbering: "1.1")
#outline()
#pagebreak()

// Links
// #let raytracing_in_one_weekend = link("https://raytracing.github.io/")[*Raytracing in one weekend*]s
#let raytracing_in_one_weekend = [*Raytracing in one weekend* @RayTracingInOneWeekend]
#let raytracing_serie = [*Ray Tracing in One Weekend — The Book Series* @RayTracingInOneWeekend @RayTracingTheNextWeek @RayTracingTheRestOfYourLife]

#let pbrb = [*Physically Based Rendering:
  From Theory To Implementation* @PbrBook]

// #let vk_guide = link("https://vkguide.dev/")[*VulkanGuide*]
#let vk_guide = [*VulkanGuide* @VkGuide]
// #let shuang_zhao = link("https://projects.shuangz.com/psdr-sg20/")[*Path-Space Differentiable Rendering*]
#let shuang_zhao = [*Path-Space Differentiable Rendering* @PathSpaceDifferentiableRendering]

// #let suisses = link("https://rgl.epfl.ch/publications/Zeltner2021MonteCarlo")[*Monte Carlo Estimators for Differential Light Transport*]
#let suisses = [*Monte Carlo Estimators for Differential Light Transport* @Zeltner2021MonteCarlo]

// #let equation_rendu = link("https://fr.wikipedia.org/wiki/%C3%89quation_du_rendu")[*Page Wikipedia Equation du Rendu*]
#let equation_rendu = [*The Rendering Equation* @kajiya:TheRenderingEq]

// #let metropolis = link("https://fr.wikipedia.org/wiki/Metropolis_light_transport")[*Metropolis Ligth Transport*]
#let metropolis = [*Metropolis Ligth Transport* @wiki:Metropolis_light_transport]

// #let VCM = link("https://www.iliyan.com/publications/ImplementingVCM/")[*Vertex Connection and Merging*]
#let VCM = [*Vertex Connection and Merging* @Georgiev:ImplementingVCM]

// #let cone = link("https://en.wikipedia.org/wiki/Cone_tracing")[*Cone Tracing*]
#let cone = [*Cone Tracing* @wiki:Cone_tracing]

// #let splating = link("https://fr.wikipedia.org/wiki/Gaussian_splatting")[*Gaussian Splating*]
#let splating = [*Gaussian Splatting* @wiki:Gaussian_splatting]

// #let Veach_equation_du_rendu_chemin = link("https://graphics.stanford.edu/papers/metro/metro.pdf")[*Metropolis Light Transport*]
#let Veach_equation_du_rendu_chemin = [*Robust Monte Carlo Methods for Light Transport Simulation* @veach:PathTracing]

// #let mecha_fluide = link("https://scispace.com/pdf/transport-relations-for-surface-integrals-arising-in-the-2up2mjqykl.pdf")[*Transport relations for surface integrals arising in the formulation of balance laws for evolving fluid interfaces*]
#let mecha_fluide = [*Transport Relations for Surface Integrals Arising in the Formulation of Balance Laws for Evolving Fluid Interfaces* @CERMELLI_FRIED_GURTIN_2005]

// #let reynolds = link("https://academicweb.nd.edu/~powers/ame.20231/reynolds1903.pdf")[*The Sub-Mechanics of the Universe*]
#let reynolds = [*The Sub-Mechanics of the Universe* @Reynold:SubMechOfTheUniverse]

#let slang = [*Slang* @SlangDoc]

#let ptvk(x) = link("https://github.com/CorentinVaillant/Vk-Path-Tracer")[#x]

#let raytracing1980 = [*An Improved Illumination Model for Shaded Display* @ImprovedIluminationModelForShadedDisplay]

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
#let extended_boundary(func, para) = $overline(partial #ensemble_surfaces)\[#func]\(#para)$
#let vel_loc = $v$
#let vel_scal = $V$
#let vel_tan = $#vel_loc _("tan")$
#let norm_field = $scr(cal(n))$
#let x_hat = $bold(hat(x))$

= Introduction

Le rendu différentiel est une branche de l'informatique graphique où l'on cherche à trouver
la différentielle de l'image d'un rendu d'une scène, ce qui est très utile dans de nombreux domaines.
Il possède de nombreuses applications, notamment dans le rendu plus classique, car il permet de faire varier des paramètres de la scène sans obligation de rendre la scène une nouvelle fois de zéro, ce qui peut être très couteux.
Il est aussi utile dans le rendu physiquement réaliste parce qu'il a permis de résoudre des problèmes d'analyse-par-synthèse dans des domaines comme le rendu de vêtements ou encore la création de matériaux translucides.
Son utilité ne se limite pas qu'au rendu, il possède aussi des applications dans le domaine du machine learning car il permet  d'entrainer des réseaux de neurones de manière plus efficace.
Le rendu différentiel a une communauté de recherche très active.
En effet ce domaine est très challengeant parce qu'à ce jour aucun algorithme efficace n'introduisant pas de biais n'a été découvert. Cela est notamment dû au fait de l'absence d'estimateurs de Monte Carlo efficaces.

Dans ce TER, nous nous sommes intéressés aux travaux de _Cheng Zhang_, _Bailey Miller_, _Kai Yan_, _Ioannis Gkioulekas_ et _Shuang Zhao_ (#shuang_zhao) qui proposent une solution sans biais à ce problème basée sur la séparation en deux sous-problèmes.

Pour effectuer ce TER, nous nous sommes aussi intéressés au ray tracing ainsi qu'au path tracing, notamment grâce à la série de livres #raytracing_serie, dans le but d'acquérir les bases nécessaires à la compréhension du papier.

Dans le cadre de ce travail, nous avons aussi tenté d'implanter un Path Tracer sur GPU avec Vulkan (#ptvk[*Github vers les projet*]).

Nous allons introduire dans un premier temps le ray tracing ainsi que ses limites. Puis nous regarderons ce qu'est le Path Tracing  et comment il corrige les limites du Ray Tracing. Dans un troisième temps, nous parlerons du rendu différentiel et de la méthode proposée par _Shuang Zhao_ et son équipe.
Enfin nous finirons par regarder une autre approche à ce problème avec les travaux de _Tizian Zeltner_, _Sébastien Speierer_, _Iliyan Georgiev_ et _Wenzel Jakob_ (#suisses).

= Le Rendu

== L'équation du rendu

Pour effectuer un rendu 3D, nous allons essayer de calculer la luminance des différentes surfaces de notre scène.
La luminance représente la luminosité que l'œil humain perçoit, provenant d'une surface qui émet de la lumière soit en tant que source de lumière, soit par réflexion ou transmission.
L'équation du rendu nous permet de calculer la luminance sur les différentes surfaces de notre scène 3D. Cette équation provient de la physique et a été introduite dans le domaine de l'informatique graphique par _Kajiya_ en 1986 dans #equation_rendu. Elle considère que le milieu entre les différents matériaux a un indice de réfraction homogène, notamment comme dans le vide, et elle ne se base que sur les principes d'optique géométrique sans prendre en compte les principes d'optique ondulatoire, ce qui exclut le traitement de la diffraction.
On peut la définir comme ci-dessous :

#definition(title: "Equation du Rendu")[
  #let Lo(o, w) = $L_o\(#o,#w)$
  #let Le(o, w) = $L_e\(#o,#w)$
  #let Li(o, w) = $L_i\(#o,#w)$
  #let cosbar(x) = $overline(cos(#x))$
  #let fi(x, wo, wi) = $f_(i)(#x,#wo,#wi)$
  $
    Lo(x, omega_o) = Le(x, omega_o) + integral_Omega Li(x, omega_i) fi(x, omega_o, omega_i) cosbar(theta_i) d omega_i
  $ <équation_rendu>


  - $Lo(x, omega_o)$ représente la luminance sortante au point $x$ dans la direction $omega_o$.
  - $Le(x, omega_o)$ représente la luminance émise par le point $x$ dans la direction $omega_o$.
  - $Omega$ représente la sphère de rayon 1 autour du point $x$.
  - $Li(x, omega_i)$ représente la luminance arrivant en $x$ depuis la direction $omega_i$ et elle est définie de la manière suivante : $L_i\(x,omega_i)=L_o\(v\i\s(x,omega_i),-omega_i)$ où $v\i\s(x,omega_i)$ donne le premier point intersecté en partant dans la direction $omega_i$ a partir du point $x$.
  - $fi(x, omega_o, omega_i)$ représente la BSDF (Bidirectional Scatering Distribution Function) qui nous donne la distribution de la luminance arrivant en $x$ depuis la direction $omega_i$ et dispersé dans la direction $omega_o$, il s'agit en faite d'une fonction décrivant les propriété photométrique d'une matière.
  // @JulienLEFEBV > Je ne vois pas quoi dire de plus, qui serait utile, et qui ne rentrerais pas dans de trops grandes explications
  - $theta$ représente l'angle formé $omega_i$ et la $arrow(n)$ normale de la surface.
  - $cosbar(theta)=cos(theta)$ si $cos(theta)>0$ sinon $0$.
]

L'un des problèmes de cette équation est que l'on ne peut pas résoudre l'intégrale de façon analytique dans la grande majorité des cas, notamment en raison de sa nature récursive.
De plus cette intégrale est convergente grâce au principe physique de la conservation de l'énergie.
C'est pour cela que des méthodes pour estimer cette intégrale ont été mises en place.

== Par quadrature : le Ray Tracing

<raytracing_def>
#definition(title: "Rayon")[
  On appelle rayon un couple $#rayon("r")=(o, arrow(d)) in RR^3 times UU(RR^3)$ où $o$ est un point désignant l'origine du rayon et $arrow(d)$ est un vecteur unitaire désignant la direction du rayon. À noter que la direction n'est pas nécessairement unitaire, mais nous la prendrons ainsi sans perte de généralité pour des raisons de simplicité dans le reste de ce rapport.
]

Le ray tracing (lancer de rayons dans la langue de Molière) est un algorithme permettant d'estimer l'équation du rendu (@équation_rendu). Il a notamment été formulé par _Whitted_ en 1980 dans son papier #raytracing1980.
Cet algorithme se base sur une technique de lancer de rayons à partir de la caméra vers la scène, c'est-à-dire dans le sens inverse de la lumière.
Ceci nous donne le même résultat que dans le sens de la lumière d'après le principe du retour inverse de la lumière de Fermat.
Pour estimer l'intégrale, l'algorithme va discrétiser la sphère unité de l'intégrale du rendu. En effet, il va seulement prendre en compte les directions partant vers les lumières de la scène pour l'éclairage direct et pour l'éclairage indirect, il va prendre les directions données par les lois de Snell-Descartes de réflexion et réfraction de la lumière. En faisant cela, il effectue une quadrature de notre intégrale du rendu. On peut en déduire l'algorithme suivant :

#algorithm-figure(
  "Ray Tracer",
  inset: 0.25em,
  indent: 0.5em,
  vstroke: 0pt + luma(200),
  line-numbers-format: x => [#x:],
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
        Comment([Eclairage Direct])
        Assign([EclairageDirect], [0])
        For([$L_j$ les vecteurs vers les lumières visibles], Assign(
          [EclairageDirect],
          [EclairageDirect + surface.normale $dot$ $L_j$],
        ))
        Assign([EclairageDirect], [$"surface."k_d times$ EclairageDirect])
        Comment([Eclairage Indirecte])
        Assign([#rayon_dir("r")],[$#rayon_dir("r") \/ |#rayon_dir("r") dot "surface.normale"|$])
        Assign([#rayon("réflexion")], [$("intersection.point",#rayon_dir("r")+2 times "surface.normale")$])
        Assign(
          [$k_f$],
          [$(("surface."k_n)^2 times |#rayon_dir("r")|^2 - |#rayon_dir("r") + "surface.normale"|^2)^(-1/2)$],
        )
        Assign(
          [#rayon("refraction")],
          [$("intersection.point",k_f times ("surface.normale" + #rayon_dir("r")) - "surface.normale" )$],
        )
        Assign(
          [EclairageIndirect],
          [$"surface."k_s times L_i (#rayon("réflexion")) + "surface."k_t times L_i (#rayon("réfraction"))$],
        )
        Return[$L_e + "EclairageDirect" + "EclairageIndirect"$]
      },
    )
  },
)

Avec $k_d$ la constante de réflexion diffuse, $k_s$ le coefficient de réflexion spéculaire, $k_t$ le coefficient de translucides et $k_n$ l'indice de réfraction.

== Les méthodes de Monte Carlo

En informatique, lorsqu'il s'agit de résoudre un problème impliquant
le calcul d'une valeur numérique, nous utilisons souvent des méthodes
dites de « Monte Carlo », en référence au célèbre casino qui s'y trouve.
L'idée est d'approcher une valeur numérique à l'aide de procédés
aléatoires empiriques. Cela s'avère particulièrement utile pour calculer
des intégrales sur des domaines non triviaux ($RR^n$, espace des
chemins, ...).

Voici comment approcher la valeur d'une intégrale grâce aux méthodes
de Monte Carlo :

Soit $phi$ une fonction continue par morceaux sur $Omega$, on note
$I := integral_Omega phi(x) dif x$, et on suppose que $I$ converge.

On dispose d'une variable aléatoire $U$ de densité $f$ et de support $Omega$
($i.e. integral_Omega f(x) dif x = 1$).

On cherche à calculer $I = EE(phi(U) \/ f(U))$. Cette quantité peut
être approchée de manière empirique grâce au théorème du transfert :

#figure([
  $display(overline(phi(U))_N = 1/N sum_(i=1)^N phi(U(omega_i)) / f(U(omega_i)))$,

  où $(omega_i)_(1 <= i <= N) in "supp"(U)^N$
  et $"supp"(U)$ désigne le support de $U$.
])

La loi des grands nombres nous permet d'avoir que cet estimateur converge presque sûrement
vers $I$ lorsque $N -> +oo$ :

$ overline(phi(U))_N -->_(N -> +oo) I $

Le choix de $f$ nous permet d'obtenir différentes vitesse de convergences, en effet, si $f$ est concentré là où $phi$ est grand, la variance de l'estimateur sera réduite, et donc la convergence plus rapide.

Il faut néanmoins noté que si $"supp"(U) subset.neq Omega$, l'estimateur sera biaisé, en effet, certaines régions de l'espace d'intégrations ne serons jamais exploré, et donc leurs valeurs jamais ajouté au résultat de l'intégrale.

Les méthodes de Monte Carlo permettent donc de généraliser l'approche par quadrature présentée précédemment, en construisant un estimateur de l'équation du rendu.

Il se base aussi sur les lois de Snell-Descartes de réflexion et réfraction de la lumière.\
Il s'agit en fait d'aprocher une quadrature de la scène, à partir de rayons envoyés récursivement de manière aléatoire.


Une méthode de ray tracing s'appuyant sur la marche aléatoire :
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

Généralement, les implantations du lancer de rayons sont avec de meilleurs moyens pour estimer le prochain rayon que la marche aléatoire, afin d'obtenir une meilleure convergence.

== Par Méthode de Monte Carlo : le Path Tracing

L'équation du rendu (@équation_rendu) peut être réécrite de façon à enlever son aspect récursif. Pour cela, au lieu d'intégrer sur la sphère unité autour de chacun des points, nous allons effectuer un changement de variable et intégrer sur des chemins. Cette réécriture a été proposée par _Veach_ en 1997, notamment dans sa thèse #Veach_equation_du_rendu_chemin.

#definition(title: "Chemin de lumière et espace des chemins")[
  Soit #ensemble_surfaces l'ensemble des surfaces des objets de notre scène.
  On appelle chemin de lumière (ou light path) un vecteur $#chemin = (x_0,x_1,...,x_N)$ de $#ensemble_surfaces^(N+1)$. Les chemins commencent sur une lumière en $x_0$ pour aller jusqu'à la caméra en $x_N$.
  On appelle espace des chemins (ou path space) l'ensemble $#espace_chemins := union_(N=1)^infinity #ensemble_surfaces^(N+1)$.
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
#let g_def = $f_(s)(x_(n-1) -> x_n -> x_(n+1)) dot G(x_n <-> x_(n+1))$
#let f_def = $(product^(N-1)_(n=0)#g($x_(n+1)$, $x_(n-1)$, $x_n$)) dot #We($x_n$, $x_(N-1)$)$
#let G_def = $VV(x_n <-> x_(n+1))G_0(x_n <-> x_(n+1))$
#let G0_def = $(|arrow(n)_(x_n) dot omega_n| |arrow(n)_(x_(n+1)) dot (-omega_n)|)/(|| x_(n+1) - x_n ||^2)$

#let pt_eq(x) = $integral_#espace_chemins f(#x) dmu(#xbar)$

#definition(title: "Équation du rendu sur l'espace des chemins")[

  $ I = #pt_eq(xbar) $<équation_rendu_chemins>
  Où $mu$ est la mesure du produit des aires défini par $d mu(#chemin) := #dmu_def$ avec $A$ la mesure de l'aire d'une surface et $f(#chemin)$ est défini de la facon suivante :
  $ f(#chemin) = #f_def $ <f_équation_du_rendu_chemins>
  où $W_e$ est la sensibilité du capteur,
  dans notre cas, $W_e$ sera une constante égale à 1 car on utilise une caméra trou d'épingle et
  $ #g($x_(n+1)$, $x_(n-1)$, $x_n$) := #g_def $ <g_équation_du_rendu_chemins>
  où $f_s$ est la BSDF au point $x_n$ dans la direction arrivant de $x_(n-1)$ et allant vers $x_(n+1)$ si $n>0$ sinon $f_s:=L_e (x_0->x_1)$ où $L_e$ est l'émission de la surface $x_0$ dans la direction de $x_1$ et
  $ G(x_n <-> x_(n+1)) := #G_def $ <G_équation_du_rendu_chemins>

  où $VV (x_n <-> x_(n+1))$ vaut 1 si $x_n$ et $x_(n+1)$
  sont visibles, c'est-à-dire s'il n'y a pas de surfaces opaques entre eux, et 0 sinon et
  $ G_0(x_n <-> x_(n+1)) := #G0_def $ <G0_équation_du_rendu_chemins>
  où $omega_n$ représente le vecteur unitaire partant de $x_n$ et pointant vers $x_(n+1)$.
]

Cette réécriture de l'équation du rendu sur l'espace des chemins est ce qui nous permettra dans la suite, lorsque nous aborderons les travaux de _Shuang Zhao_ et son équipe (#shuang_zhao) de calculer la différentielle de notre scène.
En effet, on verra qu'il est possible de "rentrer" la différentielle à l'intérieur de l'intégrale et que cela nous créera deux intégrales, une intérieure (ou interior) et une de bordure (ou boundary).


Cette réécriture est aussi à la base de l'algorithme du path tracing, qui est fondamental car nous verrons qu'il est possible de le différencier.
Il se base sur une méthode de Monte Carlo pour estimer l'intégrale sur les chemins (@équation_rendu_chemins).


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
  inset: 0.25em,
  indent: 0.5em,
  vstroke: 0pt + luma(200),
  line-numbers-format: x => [#x:],
  {
    import algorithmic: *
    Procedure(
      [$L_i$],
      [Rayon $#r$],
      {
        Assign(wo, $-#r_dir$)
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
          Assign($L$, $L + beta alphadirect \/ PP_("lumières")(p_0)$)

          LineBreak
          Assign(wi, $omega ~ PP_("bsdf")$)
          Comment([$(x1,wi)$ : le rayon partant de $x1$ avec la direction $wi$])
          Assign("intersection", $"Intersection"((x1,wi))$)
          If($not"intersection"$, Break)
          Assign(alphaindirect, $f_s (x0 -> x1 -> x2) G(x0,x1)$)
          Comment([On convertie la probabilité en mesure d'aire :])
          Assign($q$, $PP_("bsdf")(wi) (|#n(x0) dot -wi |) / (|| x0 - x1||^2)$) //TODO definir #n
          Assign($beta$, $beta alphaindirect \/q$)

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

Ici, le $epsilon$ utilisé dans la boucle introduit un biais. L'idée derrière celui-ci est que lorsque le poids d'un chemin devient trop faible ($beta$), l'ajout d'illuminations à l'accumulateur $L$ devient négligeable, le biais est introduit par le fait que tous les chemins de poids strictement supérieur à $0$ ne peuvent être explorés, nous prendrons donc un sous-ensemble de notre espace d'intégrations. Le contrôle du $epsilon$ nous permet d'ajuster le biais en fonction du résultat souhaité : plus $epsilon$ sera proche de $0$, moins le biais sera présent.\
Afin de retirer le biais, nous pouvons mettre en place une méthode dite de "roulette russe", qui consiste à fixer une probabilité de terminer le chemin en fonction de $beta$. Plus $beta$ est proche de $0$, plus nous avons de chances de terminer le chemin. Cela nous permet de toujours avoir la possibilité d'explorer tous les chemins possibles.

== Autres Méthodes

De nombreuses autres méthodes existent pour résoudre l'équation du rendu et ont chacune leurs avantages mais aussi leurs inconvénients. Parmi celles-ci, on retrouve :


+ #block[La rastérisation qui, comme le ray tracing, est une quadrature de l'équation du rendu.
    Pour le rendu en temps réel, cette méthode est souvent utilisée, bien que le ray tracing soit de plus en plus mis en avant.
    Elle est non biaisée et différenciable. Mais elle reste très limitée, notamment au niveau de la différenciation et a une convergence assez lente.
    // -T-O-D-O- expliquer le principe
    // > Je ne pense pas que cela soit nécessaire, notamment avec le manque de place.
  ]

+ #block[Le photon mapping (cartographie des photons) qui se base aussi sur une technique de lancer de rayon. Il s'agit d'un estimateur de densité et
    contrairement au ray tracing et au path tracing, les rayons sont envoyés depuis les lumières et on enregistre leurs chemins dans une carte de photons.
    Puis pour effectuer le rendu, on va envoyer un rayon depuis la caméra et à son point d'intersection avec une surface, regarder la concentration de points à proximité sur la carte de photons avec un algorithme des plus proches voisins.
    Cet algorithme est biaisé, donc il n'a pas vraiment d'intérêt à être différencié, mais il joue un rôle dans la méthode proposée par _Shuang Zhao_ et son équipe (#shuang_zhao), nous en reparlerons dans la section dédiée.]

+ #block[Le bidirectional path tracing est une version améliorée du path tracing. Donc, comme lui il se base sur un estimateur de Monte Carlo. Pour améliorer la convergence, au lieu de créer des chemins uniquement depuis la caméra, il va aussi créer des chemins partant des lumières et les connecter entre eux avec un rayon de visibilité. Cela permet de conserver les avantages des chemins partant de la caméra qui permettent d'estimer la réflectance et d'avoir en plus les avantages des chemins partant des lumières pour estimer les caustiques.
    De plus cet algorithme est non biaisé mais, malheureusement, à ce jour aucune technique de différentiation n'a été découverte.]

+ #block[Bien d'autres méthodes existent, comme le #metropolis qui est un estimateur de Monte Carlo se basant sur l'algorithme de Metropolis-Hastings, le #VCM qui fusionne le bidirectional path tracing et le photon mapping, le #cone qui donne une épaisseur aux rayons, ce que ne fait pas le raytracing ou encore le #splating qui effectue le rendu à l'aide de données extraites d'image et beaucoup d'autres… //On peut en rajouter si on en trouve des sympas :)
  ]
= La Différentiation

== Differentiation par différence fini
Pour obtenir une approximation, nous pourrions utiliser la méthode des différences finies.

Pour toute fonction $cal(C)^(1)$ $f$, le théorème de Taylor nous donne pour $V$ un voisinage de $x_0$:

$h : x_0 + h in V$ \
$f(x_0 + h) = f(x_0) + f'(x_0)h + R(x_0 + h)$ : Avec $R(x_0 + h)$ le reste.\
$<=> f(x_0 + h) / h = f(x_0)/h + f'(x_0) + R(x_0 + h)/h$ \
$<=> f'(x_0) = ( f(x_0 + h) - f(x_0)) /h - R(x_0 + h)/h$ \
En assumant $R(x_0 + h)$ suffisament petit, nous avons donc :\
$f'(x_0) tilde.eq ( f(x_0 + h) - f(x_0)) /h$

Nous pouvons donc appliquer cette méthode, en utilisant $h$ assez petit.\
Ici $pi in RR$ représente un paramètre de la scène. On notera toutes les fonctions dépendant de la scène à l'aide de la syntaxe suivante $phi(pi : x_1, ... x_k)$, où $phi$ est une fonction quelconque dépendant des paramètres de la scène. \
Nous avons donc :

$partial/(partial pi) #pt_eq($pi: #xbar$) tilde.eq (#pt_eq($pi: #xbar$) - #pt_eq($pi - h: #xbar$)) / h$

La méthode est donc facile à comprendre et à implanter, mais elle souffre de deux gros inconvénients.
Premièrement, la stabilité numérique des nombres à virgule flottante. En effet, si l'on prend $h$ trop petit, les imprécisions dans le calcul deviendront de plus en plus importantes.

Et de plus, cette méthode nécessite de faire deux rendus, ce qui provoque donc le doublage du temps de calcul.

== Différentiation sur l'espace des chemins

#let alphadotdirect = $dot(alpha)_("directe")$
#let alphadotindirect = $dot(alpha)_("indirecte")$

#let interior_intr_algo = [
  #algorithm-figure(
    "Differentiation du Path Tracer : intérieur",
    inset: 0.25em,
    indent: 0.5em,
    vstroke: 0pt + luma(200),
    line-numbers-format: x => [#x:],
    {
      import algorithmic: *
      Procedure(
        [$"PT_diff_intérieur"$],
        [Rayon $#r$],
        {
          Assign(wo, $#r_dir$)
          Assign(x1, $#r_ori$)
          Assign("intersection", $"Intersection"(#r)$)
          If($not"intersection"$, Return($"LumièresDirectionelles".L_(e)(#r)$))

          Assign(x2, $"intersection"."point"$)

          Assign($(L, dot(L))$, $("intersection".L_(e)(wo), ["intersection".L_(e)(wo)]^dot)$)
          Assign($beta, dot(beta)$, $(1, 0)$)

          Comment([$epsilon > 0 "fixé."$])
          While($beta>epsilon$, {
            Comment([Éclairage direct (échantillonage de la lumière)])
            Assign(p0, $p ~ PP_("lumières")$)
            // LineComment(Assign(wi, $normalize(p0-x2)$))[direction de $x2$ vers $p0$] //! useless
            Assign($x0$, $#mouvement (p0, pi)$)

            Assign($alphadirect$, $p0. L_e (p0 -> x_1) f_s (p0 -> x1 -> x2) G(p0,x1) J(p0)$)
            Assign($alphadotdirect$, $[p0. L_e (p0 -> x_1) f_s (p0 -> x1 -> x2) G(p0,x1) J(p0)]^dot$)
            Assign($L$, $L + beta alphadirect \/ PP_("lumières")(p_0)$)
            Assign($dot(L)$, $dot(L) + (beta alphadotdirect + dot(beta) alphadirect ) \/ PP_("lumières")(p_0)$)

            LineBreak
            Assign(wi, $omega ~ PP_("bsdf")$)
            Comment([$(x1,wi)$ : le rayon partant de $x1$ avec la direction $wi$])
            Assign("intersection", $"Intersection"((x1,wi))$)
            If($not"intersection"$, Break)
            Assign(alphaindirect, $f_s (x0 -> x1 -> x2) G(x0,x1)$)
            Assign(alphadotindirect, $[f_s (x0 -> x1 -> x2) G(x0,x1)]^dot$)
            Comment([On convertie la probabilité en mesure d'aire :])
            Assign($q$, $PP_("bsdf")(wi) (|#n(x0) dot -wi |) / (|| x0 - x1||^2)$)
            Assign($beta$, $beta alphaindirect \/q$)
            Assign($dot(beta)$, $(beta alphadotindirect + dot(beta) alphaindirect) \/q$)

            LineBreak

            Comment([On continue le chemin.])
            Assign($(x2,x1)$, $(x1, x0)$)
            Assign(r, $(x1->x2)$)
          })

          Return($(L, dot(L))$)
        },
      )
    },
  )
]

#let xB = $x^B$
#let xS = $x^S$
#let xC = $x^C$

#let xB0 = $x^B_0$
#let xS0 = $x^S_0$
#let xC0 = $x^C_0$

#let wB = $omega^B$
#let betaB = $beta^B$
#let betaS = $beta^S$
#let betaD = $beta^C$
#let pS0 = $p^S_0$
#let pC0 = $p^C_0$
#let itersec_src = $"intersec"_"src"$
#let itersec_cam = $"intersec"_"cam"$
#let f_hatB = $hat(f)^B$
#let JB = $J^B$
#let boundary_intr_algo = [
  #algorithm-figure(
    "Differentiation du Path Tracer : bordure",
    inset: 0.25em,
    indent: 0.5em,
    vstroke: 0pt + luma(200),
    line-numbers-format: x => [#x:],
    {
      import algorithmic: *
      Procedure(
        [$"PT_diff_bordure"$],
        [$PP$, Bool _direct_],
        {
          Comment([Échantillonage d'un segment de bordure])
          Assign($(xB, wB)$, $(x, omega) ~ PP(x, omega)$)
          Assign($#itersec_src$, $"Intersection"((xB, -wB))$)
          Assign($#itersec_cam$, $"Intersection"((xB, wB))$)
          Comment([Si les deux rayons tapent])
          IfElseChain(
            [$#itersec_src and #itersec_cam$],
            {
              Assign($xS0$, $#itersec_src."point"$)
              Assign($xC0$, $#itersec_cam."point"$)
              LineBreak
              Assign($betaB$, $#f_hatB JB (xB, wB) \/PP(xB, wB)$)
              Assign($pS0$, $P(xS0, pi)$)
              Assign($pC0$, $P(xC0, pi)$)

              Comment([Échantillonage d'un sous chemin])
              IfElseChain(
                [_direct_],
                {
                  Assign($betaS$, $#itersec_src. L_e (xS0 -> xC0)$)
                },
                {
                  Assign($betaS$, $"Estimation du chemin source"(pC0, pS0)$)
                },
              )
              Assign($betaD$, $"Estimation du chemin de la camera"(pC0, pS0)$)
              Return($betaS betaB betaD$)
            },
            {
              Return($0$)
            },
          )
        },
      )
    },
  )
]

Avant de commencer à aborder la méthode de _Shuang Zhao_ et son équipe (#shuang_zhao) nous allons d'abord introduire quelques définitions importantes.

//@Corentin tu pourras regarder un peu l'orthographe et si il y a des trucs sus dans les équations au cas où la fatigue m'ai fait écrire nimp ? J'ai relu mais au cas où
// > :thumnsup:

#definition(title: "Configuration de référence, mouvement et déformation")[
  Soit #mat_space un manifold 2D abstrait que l'on nommera configuration de référence.
  On appelle une déformation de #mat_space une fonction injective différentiable de #mat_space sur une surface #ensemble_surfaces.
  On appelle #mouvement un mouvement de #mat_space une fonction $cal(C)^3$ de $#mat_space times RR$ dans #ensemble_surfaces.
  De plus nous pouvons remarquer que si on fixe un paramètre $pi in RR$, alors $#mouvement\(dot,pi)$ est une déformation de #mat_space.
]

#definition(title: "Surface évoluante, carte de référence et trajectoire")[
  Pour un mouvement #mouvement et un paramètre $pi$, on appelle surface évoluante l'image $#ensemble_surfaces\(pi) := {#mouvement\(p,pi) : p in #mat_space} in RR^3$ de la fonction $#mouvement\(p,pi)$.
  De plus, comme cette fonction est injective, on peut définir une fonction inverse sur son image $P(dot,pi) : #ensemble_surfaces\(pi) -> #mat_space$ que l'on appellera carte de référence.
  Enfin on appellera trajectoire l'ensemble $#trajectoire$ des couples $(x,pi) in #ensemble_surfaces\(pi) times RR$ des surfaces évoluantes et de leur paramètre $pi$ associé.
]

#definition(title: "Espace des matériaux et espace des positions")[
  On appellera $p in #mat_space$ un point de matériau et $x in #ensemble_surfaces\(pi)$ un point de position.
  Nous pouvons aussi remarquer que la déformation $#mouvement\(dot,pi)$ établit une bijection entre les points de matériau et les points de position.
  On appellera champ de matériau une fonction de $#mat_space times RR$ et champ de position une fonction sur la trajectoire $#trajectoire$.
]

#figure(
  image("Images/mat_space.svg", width: 50%,height:15%),
  caption: [Espace des matériaux et espace des positions],
)

#definition(title: "Paramétrisation local")[
  Pour une trajectoire $cal(T)$ nous pouvons définir une paramétrisation locale, proche de $(x, pi) in cal(T)$.
  On fixe $hat(x)(xi, pi')$, qui pour un ouvert $cal(O) in RR^2$ :
  - $#x_hat (cal(O), pi) subset #ensemble_surfaces (pi)$
  - $forall pi'$ proche de $pi$ : $#x_hat (dot, pi')$ est $cal(C)^1$ et injectif.
  - $forall xi in cal(O) : #x_hat (xi, dot)$ est $cal(C)^1$ sur un voisinage de $pi$.
]

#definition(title: "Vitesse")[
  Avec $x in cal(M)(pi)$ et la paramétrisation #x_hat, il existe un unique $xi in cal(O)$ qui satisfait $#x_hat (xi, pi) = x$.
  On note $xi$ comme étant les coordonnées locales de $x$.\
  On peut donc définir la vitesse local de $x$ comme :

  $ #vel_loc (x, pi) = (partial #x_hat (xi, pi'))/(partial pi') |_(pi' = pi) $ <vitesse_loc>

  Et donc en utilisant $cal(M)(pi)$ orienté par un champ de vecteurs normaux $#norm_field (x, pi)$, on définit $#vel_scal = #vel_loc dot #norm_field$ et
  $#vel_tan = #vel_loc - #vel_scal #norm_field$, respectivement, la vitesse scalaire locale et la vitesse tangentielle locale.
]

Pour les définitions, nous allons poser $phi\(x,pi)$ un champ de position scalaire sur $#ensemble_surfaces\(pi)$.

#definition(title: "Dérivée de scène")[
  $phi$ admet une dérivée de scène de la forme :
  $ dot(phi)\(x,pi) = partial / (partial pi') phi(hat(x)\(xi, pi'),pi') |_(pi'=pi) $ <derivée_scene>
  Elle admet aussi une forme normalisée de cette dérivée :
  $ phi^square = dot(phi) - v_tan dot "grad"_#ensemble_surfaces (phi) $ <derivée_norm_scene>
]

#definition(title: "Courbes de discontinuité et bordure étendue")[
  La fonction $phi$ est $cal(C)^0$ en fonction de $x$ sauf sur un ensemble de courbes qui évolue de façon continue en fonction de $pi$. On pose $Delta#ensemble_surfaces\[phi]\(pi) subset #ensemble_surfaces\(pi)$ l'ensemble de ces courbes de discontinuité. On appellera #extended_boundary($phi$, $pi$) la bordure étendue l'ensemble des bordures de $#ensemble_surfaces\(pi)$ et des courbes de discontinuité.
]

En utilisant la relation de transport venant de la mécanique des fluides par _Cermelli_ (#mecha_fluide) on peut obtenir :

$ d / (d pi) integral_#ensemble_surfaces phi d A = I_"intérieur" + I_"bordure" $ <int_interieur_et_bordure>
Avec $ I_"intérieur" = integral_#ensemble_surfaces (phi^square - phi kappa V)d A $
$ I_"bordure"= integral_overline(partial #ensemble_surfaces) Delta phi V_overline(partial #ensemble_surfaces)d cal(l) $
Avec $cal(l)$ la mesure de la longueur des courbes, $kappa$ la courbure totale, $V$ et $V_overline(partial #ensemble_surfaces)$ les vitesses normales scalaires de $#ensemble_surfaces\(pi)$ et de la bordure étendue et $Delta phi(x, pi)$ le prolongement défini comme ci-dessous :
$
  Delta phi(x, pi) := cases(
    phi(x, pi) "si" x in partial#ensemble_surfaces\(pi\),
    phi^-(x,pi) - phi^+(x,pi) "si" x in Delta#ensemble_surfaces\(pi\)
  )
$
Nous pouvons, dans le cas particulier où #ensemble_surfaces est indépendant des paramètres de la scène, simplifier cette relation (@int_interieur_et_bordure) à la relation de transport standard de _Reynolds_ (#reynolds) :
$
  d / (d pi) integral_#ensemble_surfaces phi d A = integral_#ensemble_surfaces dot(phi) d A + integral_(Delta#ensemble_surfaces) Delta phi V_(Delta#ensemble_surfaces)d cal(l)
$ <int_avec_reynolds>

Nous allons par la suite essayer d'appliquer cette relation (@int_avec_reynolds) à l'équation du rendu (@équation_rendu_chemins). Nous allons d'abord nous concentrer sur le cas de l'éclairement direct. Pour ce faire, nous allons nous placer dans une configuration où une surface $#ensemble_surfaces _"obj"$ est éclairée par une surface évoluante $cal(L)\(pi)$. Dans cette configuration pour $y,y' in #ensemble_surfaces _"obj"$ on a :

$ I_"direct" = integral_cal(L) f_"direct"\(x) d A(x) $ <eclairement_direct>

avec $f_"direct"\(x) := L_e (x -> y) f_s (x -> y -> y') G(x <-> y)$

#figure(
  image("Images/scene_direct2.svg", width: 50%,height:20%),
  caption: [Exemple de configuration],
)

Pour simplifier la dérivation, nous allons poser les axiomes suivants :

*A.1* Pour tout $x in cal(L)\(pi)$ il existe une paramétrisation tel que x possède une vitesse tangentielle nulle.

*A.2* $L_e\(x->y)f_s\(x->y->y')$ est continue par rapport à $x$ lorsque $y,y' in #ensemble_surfaces _"obj"$ sont fixées.

Sous ces deux axiomes en appliquant @int_interieur_et_bordure à $f_"direct"$ on obtient :

$
  (partial I_"direct") / (partial pi) = integral_cal(L) |dot(f)_"direct" - f_"direct" kappa V| d A + integral_overline(partial cal(L)) Delta f_"direct" V_overline(partial cal(L)) d cal(l)
$ <diff_direct_spacial>

En effet, grâce à l'axiome *A.1* nous avons que $(f_"direct")^square = dot(f)_"direct"$. De plus, sous l'effet de l'axiome *A.2* nous avons que :
$ Delta f_"direct" = L_e (x -> y) f_s (x -> y -> y') Delta G(x <-> y) $ <delta_f_direct>

Un des problèmes de cette relation (@diff_direct_spacial) est qu'elle est très couteuse à estimer dans des scènes complexes. C'est pour cela que nous allons nous placer dans l'espace des matériaux à l'aide d'un changement de variable. Nous obtenons ainsi :
$ I_"direct" = integral_cal(B) hat(f)_"direct"\(p) d A(p) $ <eclairement_direct_material>
avec $hat(f)_"direct" := f_"direct"\(x)J(p)$ avec $x = #mouvement\(p,pi)$ et $J$ le déterminant de la Jacobienne du changement de variable défini comme $J(p) = |d A(x) \/ d A(p)|$.


Comme nous intégrons sur la configuration de référence #mat_space qui ne dépend pas du paramètre $pi$ nous pouvons appliquer la relation de _Reynolds_ (@int_avec_reynolds) ce qui nous donne :
$
  (partial I_"direct") / (partial pi) = integral_#mat_space (hat(f)_"direct")^dot d A + integral_(Delta #mat_space) Delta hat(f)_"direct" V_(Delta #mat_space) d cal(l)
$ <diff_direct_material>

Nous allons maintenant essayer de généraliser cette relation. Pour ce faire, nous allons utiliser le fait que $I=sum^infinity_(N=1) I_N$ où $I_N$ est l'intégrale du rendu (@équation_rendu_chemins) restreinte aux chemins de taille $N$. Nous allons commencer par réécrire $I_N$ de façon récursive. Pour ce faire, nous allons poser les fonctions $h_n$ telles que :

$ h_N\(x_N;x_(N-1)) := W_e\(x_N -> x_(N-1)) $ <hN>
et pour tout $0 <= n < N$ :
$ h_n := integral_#ensemble_surfaces g(x_(n+1);x_(n-1),x_n) h_(n+1)(x_(n+1);x_n) d A(x_(n+1)) $ <hn>

Ce qui permet d'obtenir :
$ h_0\(x_0) = integral_(#ensemble_surfaces^N) f(overline(x)) product^N_(n=1) d A(x_n) $ <h0>
$ I_N = integral_#ensemble_surfaces h_0(x_0) d A(x_0) $ <In_h0>

Nous pouvons appliquer à $h_n$ la relation de transport (@int_interieur_et_bordure) ce qui nous donne :
$
  dot(h)_n = integral_#ensemble_surfaces \[(h_(n+1)g)^dot-h_(n+1)g kappa V] d A + integral_overline(partial #ensemble_surfaces)_(n+1) h_(n+1) Delta g V_overline(partial #ensemble_surfaces)_(n+1) d cal(l)
$ <hndot>

Comme pour le cas direct dans l'espace des positions, grâce à l'axiome *A.1* nous avons que $(h_(n+1)g)^square = (h_(n+1)g)^dot$.

Nous pouvons ainsi différencier $I_N$ en développant successivement les $h_n$ et $dot(h)_n$ et nous obtenons ainsi :
$
  (partial I_N) / (partial pi) = integral_(Omega_N) [dot(f)(overline(x)) - f(overline(x)) sum^N_(K=0) kappa(x_K) V(x_K)] d mu (overline(x)) \ + sum^N_(K=0) [integral_(partial Omega_(N,K)) Delta f_K (overline(x)) V_overline(partial #ensemble_surfaces)_k (x_k) d mu'_(N,K)(overline(x))]
$ <big_diff_In>

où : $ partial Omega_(N,K) := underbrace(M(pi)^K, "chemin vers la lumière")times underbrace(overline(partial #ensemble_surfaces)_K (pi), "point de discontinuité") times underbrace(#ensemble_surfaces\(pi\)^(N-K), "chemin vers la caméra") $ <omegaNK>

$ d mu'_(N,K) := d cal(l)(x_k) product_(0<=n<=N \ n != K) d A (x_n) $ <mu_prime>

$ Delta f_K (overline(x)) = (f(overline(x)) Delta g(x_K;x_(K-2),x_(K-1))) / g(x_K;x_(K-2),x_(K-1)) $ <delta_f>

Ainsi nous pouvons sommer la différentielle des $I_N$ (@big_diff_In) pour obtenir la différentielle de $I$ on a ainsi :
$
  (partial I)/(partial pi) = integral_Omega [dot(f)(overline(x))-f(overline(x)) sum^N_(K=0) kappa (x_K) V(x_K)] d mu (overline(x)) \ + integral_(partial Omega) Delta f_K (overline(x)) V_(overline(partial #ensemble_surfaces)_K) (x_K) d mu'(overline(x))
$ <diff_I_spatial>
où $partial Omega = union^infinity_(N=1) union^N_(K=0) partial Omega_(N,K)$ et $mu'(D):= sum^infinity_(N=1) sum^N_(K=0) mu'_(N,K) (D inter partial Omega_(N,K))$.

Comme pour le cas direct, nous pouvons effectuer un changement de variable pour nous placer dans l'espace des matériaux. Nous allons d'abord passer l'intégrale du rendu (@équation_rendu_chemins) dans l'espace des matériaux en effectuant un changement de variable :

$ I = integral_hat(Omega) hat(f) (overline(p)) d mu (overline(p)) $ <équation_rendu_mat_space>
avec $hat(Omega) := union^infinity_(N=1) cal(B)^(N+1)$ et :
$ hat(f)(overline(p)) = (product^(N-1)_(n=0) hat(g) (p_(n+1); p_(n-1),p_n)) hat(W)_e (p_N -> p_(N-1)) $ <f_hat>

où :
$ hat(W)_e (p_N -> p_(N-1)) : = J(p_N) W_e (p_N -> p_(N-1)) $ <We_hat>
et $ hat(g) (p_(n+1); p_(n-1),p_n)) = underbrace(hat(f)_s (p_(n-1)-> p_n -> p_(n+1)), J(p_n) f_s (x_(n-1)-> x_n -> x_(n+1))) G(x_n<->x_(n+1)) $ <g_hat>
où $J$ est le déterminant de la Jacobienne $J(p_n)=|d A(x_n) \/ d A(p_n)|$

On obtient ainsi :

$
  (partial I)/(partial pi) = integral_hat(Omega) (hat(f))^dot (overline(p)) d mu (overline(p)) + integral_(partial hat(Omega)) Delta hat(f)_K (overline(p)) V_(Delta cal(B)_K) (p_K) d mu' (overline(p))
$ <diff_mat_space>

Nous allons maintenant voir les estimateurs de Monte Carlo permettant d'estimer l'intégrale intérieure et l'intégrale de bordure. Pour l'intégrale intérieure, du fait de sa ressemblance avec l'intégrale du rendu, nous pouvons construire notre estimateur sur la base de l'algorithme du path tracer :


#interior_intr_algo

#definition(title: "Sous chemin de source et sous chemin de caméra")[
  Soit $overline(p) = (p^S_s,...,p^S_0,p^C_0,...,p^C_t)$ un chemin dans l'espace des matériaux, on appelle $overline(p)^S = (p^S_s,...,p^S_1)$ le sous-chemin vers la source, il connecte $p^S_0$ à une source de lumière, et $overline(p)^C = (p^C_1,...,p^C_t)$ le sous-chemin vers la caméra, il connecte $p^C_0$ à la caméra.
]

#figure(
  image("Images/bidir_edge.svg", width: 50%,height:15%),
  caption: [Exemple d'un sous chemin de source et d'un sous chemin de caméra],
)

Nous allons réécrire l'intégrale de bordure de manière à, pour un point de discontinuité entre $p^S_0$ et $p^C_0$, prendre en compte le sous-chemin de source et le sous-chemin de caméra :
$ integral_(partial hat(Omega)) hat(f)^S hat(f)^B hat(f)^C $ <bordure_1>
avec :
$ hat(f)^B := Delta G(x_0^S <-> x^C_0)V_(Delta #mat_space) $ <fb_hat>
$
  hat(f)^S := hat(f)_s (p_1^S-> p_0^S -> p_0^C) product^s_(n=1) hat(f)_s (p_(n+1)^S-> p_n^S -> p_(n-1)^S) G(x_(n-1)^S <->x_n^S)
$ <fs_hat>
$
  hat(f)^C := hat(f)_s (p_0^S-> p_0^C -> p_1^C) product^s_(n=1) hat(f)_s (p_(n-1)^C-> p_n^C -> p_(n+1)^C) G(x_(n-1)^C <->x_n^C)
$ <fc_hat>

Nous pouvons réécrire cela sous la forme :
$
  integral_#mat_space integral_(Delta #mat_space) [integral_hat(Omega) hat(f)^S d mu (overline(p)^S)] hat(f)^B [integral_hat(Omega) hat(f)^C d mu (overline(p)^C)] d cal(l) (p_0^C) d A (p_0^S)
$ <bordure_2>

Pour pouvoir échantillonner un point sur la bordure, nous allons effectuer un changement de variable pour passer de $p_0^S$ et $p_0^C$ à $x^B$ le point de discontinuité, et $omega^B := x_0^S -> x_0^C$ :

$
  integral.triple [integral_hat(Omega) hat(f)^S d mu (overline(p)^S)] hat(f)^B J^B (x^B,omega^B) [integral_hat(Omega) hat(f)^C d mu (overline(p)^C)] d omega^B d x^B
$ <bordure_3>

où $ J^B (x^B,omega^B) = |(d A(x_0^S)d cal(l)(x_0^C))/(d x^B d omega^B)||(d A(p_0^S)d cal(l)(p_0^C))/(d A (x_0^S) d cal(l)(x_0^C))| $

Grâce à cela nous pouvons créer l'estimateur de Monte Carlo suivant :

#boundary_intr_algo

Pour l'échantillonnage du point de discontinuité et de la direction, nous pourrions utiliser une distribution uniforme, mais cela pourrait donner une convergence lente. C'est pour cela que nous pouvons utiliser une carte de photons (issue du photon mapping) et une carte d'importance (issue d'un photon mapping partant de la caméra). Pour voir plus en détail comment nous pouvons mettre en place cet échantillonnage, veuillez consulter le travail de _Shuang Zhao_ et son équipe (#shuang_zhao). //@Corentin Je detail pas plus il est tard et en plus j'ai peur pour la place honnêtement. Enfin à voir :p

== Différentiation des estimateurs

Contrairement à _Shuang Zhao_ et son équipe, _Tizian Zeltner_, _Sébastien Speierer_, _Iliyan Georgiev_ et _Wenzel Jakob_ ont proposé une méthode pour calculer la différentielle sans utiliser le calcul du rendu en lui-même. Pour cela ils ont créé plusieurs estimateurs en appliquant différentes méthodes dans différents ordres. Cela leur a permis d'obtenir des estimateurs "détachés" et "attachés" au paramètre $pi$ de la scène. Ainsi, en combinant ces méthodes à l'aide du multi-importance sampling, qui consiste à effectuer plusieurs méthodes d'échantillonnage et à les additionner en leur attribuant un certain poids en fonction de leur efficacité, ils parviennent à calculer la différentielle de la scène. Pour plus d'informations, veuillez consulter #suisses. //@Corentin Je sais pas trop en terme de place peut être que je développerai un peu plus à l'avenir mais ça me semble bon (puis j'ai la flemme de me replonger dans le papelard à 6 heure du mat bruh) (si ça te vas pas tu as le droit de me detester par ailleur) bon au lit zzzzzzzzzz
// Bonne nuit Julien, c'est parfait (comme toi mon cher)

// implantation
= Implantation des algorithme

Afin de pouvoir comprendre les algorithmes étudiés, nous avons implanté un ray tracer et un path tracer.

== Premier ray tracer

Nous avons donc commencé par suivre une série de tutoriels : #raytracing_serie, écrit principalement par _Peter Shirley_.\
Le but de ces tutoriels était d'implanter, en `C++`, un premier ray tracer.


Cela nous à permis de comprendre le ray tracing de façon concrète, nous avons écrit plusieurs abstractions (formes, matériaux, textures, caméra, _ect_..), qui nous ont ensuite permis d'appliquer les mathématiques de l'algorithme.

Cette première implantation souffrait de la faible parallélisation du `CPU`. En effet, les temps de rendu pouvaient être très longs.

#let rtowe_caption = "Scène rendue à partir du ray tracer implanté, le temps de rendu est d'environ 3 minutes (CPU 3.5 GHz)."
#let rtowe = image("Images/Rt_series/rtowe.png", width: 67%, alt: rtowe_caption)

#figure(rtowe, caption: rtowe_caption)

== Autres implantation `CPU`

La suite des tutoriels de _Peter Shirley_ nous a amenés à construire des rendus plus élaborés.
Nous avons donc ajouté la possibilité d'avoir des matériaux volumétriques et des textures.

#let vol_text_caption = "Scène rendue à partir du ray tracer CPU implanté."
#let vol_text = image("Images/Rt_series/text_plus_vol.png", width: 65%, alt: vol_text_caption)

#figure(vol_text, caption: vol_text_caption)

Afin d'accélérer le processus, nous avons implanté divers moyens d'accélérer le processus, comme des `BVH` (Bounding Volume Hierarchy, comprendre hiérarchie des volumes englobants), et des méthodes de Monte Carlo plus efficaces, par exemple, au lieu d'opérer la progression des rayons à partir d'une marche aléatoire à direction uniforme, nous tirons une direction en fonction de la distribution de la `BRDF`.

Au fur et à mesure, le tutoriel nous amène à construire un path tracer, les nouvelles directions sont donc tirées en fonction du placement des lumières, et l'on passe d'un programme récursif à terminal-récursif.

De plus, nous avons ajouté quelques fonctionnalités supplémentaires, telles que le chargement de maillage et le multi-threading.

#let vol_text_caption = "Scène rendue à partir du path tracer CPU implanté."
#let vol_text = image("Images/Rt_series/dragon.png", width: 65%, alt: vol_text_caption)

#figure(vol_text, caption: vol_text_caption)


== Passage sur GPU

Pour la suite, nous avons décidé d'utiliser `Vulkan` pour une implantation sur `GPU`.
`Vulkan` est une spécification proposée par _Khronos Group_ (qui propose aussi `OpenGL`), qui a vocation à remplacer `OpenGL`.
`Vulkan` nous permet d'avoir un grand contrôle sur la carte graphique, mais comme le dit l'adage : "Un grand pouvoir implique de grandes responsabilités", la spécification est donc dure à prendre en main, avec un débogage compliqué, et une quantité de code à écrire conséquente.\
Afin de nous aider, nous avons encore une fois suivi un tutoriel : #vk_guide, qui nous a permis d'implanter un simple moteur graphique de rasterization.\
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

Afin de structurer le code, nous avons lu (en partie) le livre #pbrb, qui aborde l'implantation complète d'un moteur de rendu efficace, avec une approche moderne (en `C++`).

De plus, nous avons utilisé le langage de shader #slang, un langage de shader qui nous permet d'exécuter du code directement sur la carte graphique. Nous avons choisi ce langage car l'auto-différentiation y est implanté.

Malheureusement, le temps nous a manqué, l'implantation du ray tracer sur `Vulkan` a pris plus de temps que prévu, et la complexité des mathématiques utilisées dans l'algorithme du path tracer nous a ralentis. Le path tracer que nous voulions implanter n'a donc pas pu être fini à temps.\
Nous avons donc décidé qu'après le rendu de ce rapport, nous finaliserons l'implantation, pour à terme, y inclure les travaux de _Shuang Zhao_.

Le code pourra être trouvé sur le repo Github #ptvk[*Vulkan Path Tracer*].

= Conclusion

Au terme de ce `TER` nous avons donc vu la théorie derrière le rendu physiquement réaliste, notamment avec l'équation du rendu @kajiya:TheRenderingEq, et les abstractions mathématiques qui l'accompagnent. Nous avons ainsi pu mettre en œuvre cette théorie, grâce aux algorithmes du ray tracing @ImprovedIluminationModelForShadedDisplay et du path tracing @veach:PathTracing, en l'appliquant sur `CPU` et partiellement sur `GPU`, afin d'accélérer les temps de calcul. De plus, nous avons étudié différentes méthodes de différentiation du rendu, celle de _Zhao_, qui sépare le résultat en deux problèmes différents, avec pour le premier une simple différentiation des calculs du path tracer, et pour le second une méthode à part pour les segments de discontinuité de l'image.
Ensuite nous avons vu une méthode alternative, proposée par _Wenzel_, où la méthode consiste à différencier les estimateurs.\

Notre formation (`MIDL` à l'Université de Toulouse) nous a permis d'acquérir une solide base de connaissances permettant de faire face aux problèmes et aux solutions auxquels nous avons été confrontés durant ce stage, qui s'avérait être un excellent pont entre la théorie mathématique et ses implications en informatique. Plusieurs domaines étudiés nous ont été particulièrement utiles, comme les probabilités, l'analyse, l'algorithmique et la programmation étudiées lors de notre parcours, même si une base en théorie de la mesure et en programmation sur `GPU` aurait pu nous permettre une compréhension plus rapide de certains concepts.

Par la suite, nous aimerions terminer notre implantation sur `GPU`, notamment celle du path tracer et la méthode développée par _Zhao_. Et de plus continuer l'étude du rendu différentiel. En effet, l'équipe de _Shuang Zhao_ a peaufiné sa méthode, pour l'étendre aux milieux semi-transparents (gaz/liquides), et a amélioré l'algorithme. Il faut aussi noter que d'autres méthodes sont en cours de développement, par exemple des estimateurs de fonctionnelles développés à l'`IRIT`.\

= Annexe

Le code source de nos travaux est trouvable sur trois dépôts GitHub différents :

- Le code sources des tutoriels, et des implantations CPU sur #link("https://github.com/CorentinVaillant/travaux_TER.git").
- L'implantation du path tracer sur GPU est disponible sur #link("https://github.com/CorentinVaillant/Vk-Path-Tracer").
- Et le rapport se trouve sur #link("https://github.com/JulienLEFEBV/Rapport_TER").


#pagebreak()
#bibliography("bib.bib", style: "ieee")

