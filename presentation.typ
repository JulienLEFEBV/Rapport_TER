#import "@preview/touying:0.7.4": *
#import themes.metropolis: *

#import "@preview/algorithmic:1.0.7"
#import algorithmic: algorithm-figure, style-algorithm
#show: style-algorithm


#import "@preview/great-theorems:0.1.2": *
#import "@preview/rich-counters:0.2.1": *


#import "@preview/numbly:0.1.0": numbly

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

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-info(
    title: [Présentation rapport TER],
    subtitle: [Approche moderne du rendu différentiel],
    author: [Julien LEFEBVRE et Corentin VAILLANT],
    date: "2026",
    institution: [MIDL - FSI Université de Toulouse],
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

== Table des matières <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em))

= Introduction

#speaker-note([
  - Julien: \
  - Décrire rendu\
  - Décrire rendu différentiel\
    - Rendu inverse\
    - Modèle IA\
    - Faible variation des paramêtre\
])

#columns(2, {
  image("Images/Scene.png", height: 100%)
  colbreak()
  image("Images/SceneRender.png", height: 100%)
})

#pagebreak()

#columns(2, {
  image("Images/Diff/lapin.png", width: 100%)
  colbreak()
  image("Images/Diff/lapin_diff.png", width: 100%)
})

= Le Rendu

== L'équation de Kajiya

#speaker-note([
  - Corentin :
  - Lumière en chaque pts en fonction de la direction de vue
  - Axiome :
    - ior homgêne
    - pas d'optique ondulatoire (pas de difraction)
  - Deux partie L_i : lum entrant, L_o : lum_sortant
  - Pas résolvable
  - Conservation d'énergie => convergente
])

#table(
  definition(title: "Equation du Rendu")[
    #let Lo(o, w) = $L_o\(#o,#w)$
    #let Le(o, w) = $L_e\(#o,#w)$
    #let Li(o, w) = $L_i\(#o,#w)$
    #let cosbar(x) = $overline(cos(#x))$
    #let fi(x, wo, wi) = $f_(i)(#x,#wo,#wi)$
    $
      L_i\(x,omega_i)=L_o\(v\i\s(x,omega_i),-omega_i)
    $
    $
      Lo(x, omega_o) = overbrace(Le(x, omega_o), "Lumière émise") + overbrace(integral_Omega Li(x, omega_i) underbrace(fi(x, omega_o, omega_i), "BSDF") cosbar(theta_i) d omega_i, "Lumière transmise")
    $ <équation_rendu>
  ],
  figure(
    image("Images/eq_rendu.png", width: 48%),
  ),
)

```cpp
Lumière L_i(Rayon r, int depth){
  Intersection inter = TracerRayon(r);
  if(!inter)
    return L_e(r); // Le rayon n'intersecte pas
  Vec3 wo = -r.direction;
  Lumière L = inter.L_e(wo);
  if(depth >= MAX_DEPTH)
    return L;
  Vec3 wi = DirectionAléatoireUniforme();
  Lumière f_cos = inter.bsdf(wo,wi) * abs(dot(wi, inter.normal));
  if(f_cos == 0)
    return L;
  r = {inter.point, wi};
  return L + f_cos * L_i(r, depth +1) / (1/(4*pi));
}

```

== L'équation de Veach


#let xbar = chemin
#let dmu(x) = $d mu(#x)$
#let dmu_def = $product^(N)_(n=0) d A(x_n)$
#let We(x, y) = $W_(e)(#x -> #y)$
#let g(z, x, wn) = $g(#z : #x, #wn)$
#let g_def = $f_(n)(x_(n-1) -> x_n -> x_(n+1)) G(x_n <-> x_(n+1))$
#let f_def = $(product^(N-1)_(n=0)#g($x_(n+1)$, $x_(n-1)$, $x_n$)) #We($x_N$, $x_(N-1)$)$
#let G_def = $VV(x_n <-> x_(n+1))G_0(x_n <-> x_(n+1))$
#let G0_def = $(|arrow(n)_(x_n) dot omega_n| |arrow(n)_(x_(n+1)) dot (-omega_n)|)/(|| x_(n+1) - x_n ||^2)$

#slide()[
  #figure(
    [
      $#xbar := (x_0, x_1 ...,x_n) in #ensemble_surfaces^(n+1)$

      #image("Images/Chemin.svg", width: 50%)

      $d mu(#chemin) := #dmu_def$],
  )

  #speaker-note([
    - Corentin :
    - Suite de point sur les surface
    - Mesure : importance de chaque chemin
  ])

]

#let pt_eq(x) = $integral_#espace_chemins f_(pi)(#x) dmu(#xbar)$

#definition(title: "Équation du rendu sur l'espace des chemins")[
  $ I = #pt_eq(xbar) $<équation_rendu_chemins>
  $ f_(pi)(#chemin) := #f_def $ <f_équation_du_rendu_chemins>
  $ #g($x_(n+1)$, $x_(n-1)$, $x_n$) := #g_def $ <g_équation_du_rendu_chemins>
  $"Terme geometrique" G(x_n <-> x_(n+1)) := #G_def$ <G_équation_du_rendu_chemins>
  $ G_0(x_n <-> x_(n+1)) := #G0_def $ <G0_équation_du_rendu_chemins>
]

#speaker-note([
  - Corentin :
  - Intégrale sur l'ensemble des chemin
  - Le produit de l'importance du capteur(1) et du produit pour chaque pt du chemin de ...
])

#pagebreak()

```cpp
Lumière L_i(Rayon r){
  Intersection inter = TracerRayon(r);
  if(!inter)
    return L_e(r); // Le rayon n'intersecte pas
  Point x1 = r.origine;
  Point x2 = inter.point;

  Lumière L = inter.L_e(-r.direction); // Acumulateur lumière
  Lumière T = 1; // Accumulateur débit
  while(T > EPSILON){
    // Ajout de l'eclairage direct
    L += L_iDirect(T, x1, x2);

    // On continue le chemin pour calculer l'eclairage indirect
    r = ContinuerChemin(&T, &x1, &x2);
  }
}
```
#pagebreak()
```cpp
///@brief calcul l'eclairage direct du chemin (p ,x1, x2)
/// avec p tirer aléatoirement.
Lumière L_iDirect(Lumière T, Point x1, Point x2){
  PointLumière p = PointLumièreAléatoire();
  Vec3, wi = normaliser(p - x2);
  Lumière alpha_direct = p.L_e(RayonAllantDeÀ(p, x1))
    * f_n(p, x1, x2)*G(p, x1);
  return T*alpha_direct / Probabilité(p);
}
```

#pagebreak()

```cpp
///@brief Estimation du chemin suivant, et mis à jour du débit.
Rayon CheminSuivant(Lumière *T, Point* x1, Point* x2){
  tuple<Vec3, float> [wi, Pwi] = DirectionAléatoireBsdf(x1->bsdf);
  Intersection inter = TracerRayon(Rayon(*x1, wi));
  if(!inter){
    *T = 0; // Le chemin se termine
    return 0;
  }
  Point x0 = inter.point;
  Lumière alpha_indirect = f_n(x0, *x1, *x2)*G(x0, *x1);
  // Conversion d'une mesure d'angle en mesure d'aire
  float q = Pwi * abs(dot(x0.normal, -wi)) / dist_carre(x0, x1);
  *T *= alpha_indirect/q;
  *x2 = *x1; *x1 = x0; // On met à jour le chemin
  return RayonAllantDeÀ(*x1, *x2)
}
```

= La différentiation

#speaker-note([
  - Julien:
  - ♡♡♡ Shuang Zhao ♡♡♡
  - EPFL
])

== Différentiation dans l'espace des chemins

#figure(
  [
    $ (partial I)/(partial pi) = (partial)/(partial pi) integral_#espace_chemins f_(pi)(xbar) dmu(xbar) $
    #pause
    $ (partial I)/(partial pi) =^? integral_#espace_chemins (partial f_(pi)(xbar))/(partial pi) dmu(xbar) $
    #pause
    NON !
    #pause

    *A.1* Pour tout $x in cal(L)\(pi)$ il existe une paramétrisation tel que x possède une vitesse tangentielle nulle.

    *A.2* $L_e\(x->y)f_s\(x->y->y')$ est continue par rapport à $x$ lorsque $y,y' in #ensemble_surfaces _"obj"$ sont fixées.
  ],
)

#speaker-note([
  - Julien:
  - On essaie de rentrer la diff
  - hmmm
  - NON !
  - => On pose les axiomes
])


#slide()[
  #figure(
    [
      $
        (partial I)/(partial pi) = (partial)/(partial pi) integral_#espace_chemins f_(pi)(xbar) dmu(xbar)
      $$
        (partial I)/(partial pi) = integral_Omega [dot(f)(overline(x))-f(overline(x)) sum^N_(K=0) kappa (x_K) V(x_K)] d mu (overline(x)) \ + integral_(partial Omega) Delta f_K (overline(x)) V_(overline(partial #ensemble_surfaces)_K) (x_K) d mu'(overline(x))
      $
    ],
  )

  #speaker-note([
    - Julien:
    - Cermelli méca des fluides
  ])
]


#slide()[
  #table(
    {
      $
        I = integral_hat(Omega) hat(f) (overline(p)) d mu (overline(p)) : hat(Omega) := union^infinity_(N=1) cal(B)^(N+1)
      $
      $ hat(f)(overline(p)) = (product^(N-1)_(n=0) hat(g) (p_(n+1); p_(n-1),p_n)) hat(W)_e (p_N -> p_(N-1)) $
    },
    figure(image("Images/mat_space.svg", width: 55%, height: 40%)),
  )

  #speaker-note([
    - Julien:
    - manifold 2d ne dépend de pi
  ])

]


#slide()[
  === La relation de Reynold

  $
    d / (d pi) integral_#ensemble_surfaces phi_(pi) d A = underbrace(integral_#ensemble_surfaces dot(phi)_(pi) d A, "Intérieur") + underbrace(integral_(Delta#ensemble_surfaces) Delta phi_(pi) V_(Delta#ensemble_surfaces)d cal(l), "Bordure")
  $$
    Delta phi(x, pi) := cases(
      phi(x, pi) "si" x in partial#ensemble_surfaces\(pi\),
      phi^-(x,pi) - phi^+(x,pi) "si" x in Delta#ensemble_surfaces\(pi\)
    )
  $

  #speaker-note([
    - Julien:
    - Surface bouge pas (grâce aux mat space)

  ])

]

#slide()[
  #figure(
    [
      $
        (partial I)/(partial pi) = (partial)/(partial pi) integral_#espace_chemins f_(pi)(xbar) dmu(xbar)
      $$
        (partial I)/(partial pi) = underbrace(integral_hat(Omega) (hat(f))^dot (overline(p)) d mu (overline(p)), "Intérieur") + underbrace(integral_(partial hat(Omega)) Delta hat(f)_K (overline(p)) V_(Delta cal(B)_K) (p_K) d mu' (overline(p)), "Bordure")
      $
    ],
  )
]

#slide()[
  #figure(
    [
      $overline(p) := (p_s^S,..., p_0^S,p_0^C ...,p_t^C) in #mat_space^(n+1)$

      #image("Images/bidir_edge.svg", width: 67%, height: 50%)

    ],
  )

  #speaker-note([
    - Chemins en deux morceau $x^B in.not$ chemint
    - Chemins matériaux pas représentable => Représenter dans $RR^3$
    - Dire pt bordure xB
    - 67
  ])

]

#pagebreak()

```C
LumièreDiff PT_diff_bordure(DistribRayon P, bool direct){
  Rayon [xB,wB] = TirerRayon(P);
  Intersection inter_src = Intersection((xB,-wB));
  Intersection inter_cam = Intersection((xB,wB));
  if(inter_src && inter_cam){
    LumièreDiff TB = fHatB * JB(xB, wB) / P(xB,wB);
    float p0S =  VersMatériaux(inter_src.point,pi);
    float p0C =  VersMatériaux(inter_cam.point,pi);
    LumièreDiff TS, TC;
    if(direct) TS = inter_src.L_e(Rayon(inter_src.point, inter_cam.point));
    else  TS = EstimationCheminSource(p0C,p0S);
    TC = EstimationCheminCamera(p0C,p0S);
    return TS * TB * TC
  }
  else return 0;
}
```
#speaker-note([
  - Paramêtre de la fonctions
  - Estimation source, camera
])

== Différentiation des estimateurs

#figure(image("Images/EPFL.png", width: 100%))

= Implantation

== Ray Tracing in One Weekend

#columns(3, [

  #image("Images/Rt_series/cover/CoverRTW1.png")
  #colbreak()
  #image("Images/Rt_series/cover/CoverRTW2.png")
  #colbreak()
  #image("Images/Rt_series/cover/CoverRTW3.png")

])


#pagebreak()
#columns(2, [
  #figure(image("Images/Rt_series/cover/CoverRTW1.png"))
  #colbreak()
  #figure(image("Images/Rt_series/rtowe.png", height: 100%))])

#pagebreak()
#columns(2, [
  #figure(image("Images/Rt_series/cover/CoverRTW2.png"))
  #colbreak()
  #figure(image("Images/Rt_series/text_plus_vol.png", height: 100%))])

#pagebreak()
#columns(2, [
  #figure(image("Images/Rt_series/cover/CoverRTW3.png"))
  #colbreak()
  #figure(image("Images/Rt_series/dragon.png", height: 100%))])

== Vulkan

#figure(
  image("Images/Vulkan/logo.svg", width: 50%),
)

#columns(2, [
  #image("Images/Vulkan/KhronosLogo.svg")
  #colbreak()
  #figure(
    image("Images/Vulkan/doom.png", width: 93%),
    caption: "Doom Eternal 2020, fait avec Vulkan.",
    placement: none,
    numbering: none,
  )
])

#speaker-note([
  - Corentin :
  - Specif de 2016 par Khronos
  - À vocation à remplacer OpenGl
  - De très nombreux projet l'utilise
  - Très bas niveau
])

#pagebreak()
#image("Images/Ben.png")

#pagebreak()
#figure(
  image("Images/Vulkan/vk_guide.png"),
)


#figure(
  [
    #image("Images/Vulkan/first rt.png", width: 50%)
  ],
)

#figure(
  [
    #image("Images/Vulkan/Troute.png", width: 50%)
  ],
)

= Conclusion

#speaker-note([
  - Corentin :
  - Malheureusement pas fini => PT pas fonctionnelles
  - On continue cette été
    => Path tracer + Shuang Zhao

  - On à vu comment différentié le rendu à l'aide de plusieurs méthodes
    - Pas facile, mais formations bien pour ça !

  - Questions ?
])
