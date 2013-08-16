# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Character.destroy_all
Node.destroy_all
Link.destroy_all
Presence.destroy_all
User.destroy_all
Topic.destroy_all

# Users
User.create!({email: "juleffel@hotmail.fr", password: "password"})

topics = Topic.create!([{},{},{},{},{},{},{},{},])

# Characters
haeg = Character.create!({
    first_name: "Haeg", last_name: "Ponak", 
    birth_date: "12/05/1975".to_date,
    birth_place: "1, rue des Winners, Aeranpolis", 
    sex: true, 
    avatar_url: "http://img152.imageshack.us/img152/180/smith3et3.jpg",
    avatar_name: "Hugo Weaving",
    copyright: "Juleffel",
    story:
%{H – 5 minutes.
Le laboratoire d'Haeg était en ébullition. Tout les chercheurs étaient penchés sur les écrans tactiles pour considérer toutes les variables instables. Les chiffres digitaux étaient en changements permanents. Des messages d'alertes s'affichaient souvent. Les chercheurs les considéraient un instant pour certifier que les erreurs produites n'étaient pas trop dangereuses. L'atmosphère était pesante. Haeg avait affirmé vouloir commencer l'expérience avant que toutes les variables aient pu être considérées. Le projet était bien trop complexe pour qu'ils puissent être certains du résultat. Mais le scientifique et directeur de la Typhon Corp, une installation secrète dans les tréfonds d'Aeranpolis, avait lui même mis au point cette expérience. Ces scientifiques, choisis avec le plus grand parmi les élèves les plus intelligents des académies de Tyral, surpayés à l'extrême et surveillés où qu'ils aillent pour que l'entreprise d'Haeg reste la plus secrète possible, avaient seulement fignolé les détails, géré les arrivées de matières premières, travaillé un maximum de variables dont le directeur n'avait pas eu le temps de s'occuper, et construit les machines nécessaires à cette expérience ainsi qu'à toutes celles qui suivraient. Haeg, membre de la secte Juste Fureur, propriétaire de plusieurs grandes entreprises de Tyral et de nombreuses actions partout dans le monde parmi les sociétés les plus florissantes, et multi-milliardaire affirmé, regardait d'un oeil satisfait la sorte de four devant lui. Un mince filet d'air fit voleter un pan de sa coûteuse veste noire, taillée sur mesure par un couturier de talent, derrière lui, alors que des reflets rouges teintaient toute la salle. Un prisonnier avait été détourné avec les plus grands soins du pénitencier de Tyral pour lui servir de cobaye durant cette expérience. Grâce à une technologie de l'ADN avancée qu'il avait réussit à soutirer à un scientifique travaillant au service de l'Inquisition, il avait réussit à mettre au point une idée qui le tenait depuis longtemps. Un nouveau type de guerrier, dont la peau serait d'un métal casi-indestructible, surmontée en de nombreux points de grandes piques acérées dignes de transpercer une armure de titane ou d'acier comme si c'était du beurre, et enfin, son plus grand rêve, capable de moduler le temps à son bon vouloir en perçant l'espace temps lui même. Aucune équation de ce type n'avait jamais pu réussir, mais Haeg en était certain, la sienne n'échouerait pas.
H – 1 minute.
Haeg regarda son écran, les messages d'alertes habituels clignotaient à tort et à travers. Depuis toujours, toute expérience touchant à l'ADN ne s'était jamais passé exactement comme il fallait. La modification de cet élément était une science bien trop complexe pour que l'homme puisse en faire le tour. Mais généralement, les erreurs étaient suffisamment négligeables pour être ignorées. Le résultat final n'altérait que peu avec l'objectif qu'on voulait atteindre. C'était l'objectif, justement, qui présentait le plus souvent des problèmes. Incompatibles avec l'organisme, certaines modifications détruisaient son propriétaire. Ces modifications n'étaient simplement pas viables.
H – 30 secondes.
Haeg avait prit soin d'intégrer dans l'ADN de son oeuvre des grands principes comme obéir à son créateur, ne tuer que sous son ordre, ou défendre celui-ci dès qu'il était en danger. Il espérait ne pas s'être trompé dans ses équations. Il le saurait bien assez tôt.
H – 15 secondes.
Il le saurait bien assez tôt.
H – 10 secondes : Arrêt des systèmes nucléaires.
La lumière à l'intérieur de la forge mis quelques secondes à s'éteindre.
H – 5 seconde : Refroidissement du corps.
H – 0 secondes : Dépressurisation de la cabine et ouverture du sas.
La lourde porte commença à se soulever dans un vacarme d'enfer. Un nuage de fumée blanche sortit par en dessous de la porte et commença immédiatement à se dissiper. Un silhouette commença à prendre forme. Un monstre aux reflets d'acier, à la silhouette menaçante, haut de deux mètres de haut, hérissé de piques en tout sens, deux sphères rouges sang brillantes à l'emplacement de ses yeux. Littéralement, le gritche de Dan Simmons. Haeg s'en était hautement inspiré pour créer ce monstre, dans le livre de science fiction créé par une Intelligence Ultime créé lui même par des IA surpuissantes. Il venait de rendre ce miracle digne des humains. Il venait de se prendre pour Dieu. Le gritche avança lentement, faisant trembler le sol à chacun de ses pas. Puis arrivé au centre de la salle, il s'arrêta et regarda autour de lui. Puis il se mit à courir dans la direction d'un scientifique, et le massacre commença. Le premier scientifique fut transpercé d'une pique avant de pouvoir réagir, puis un deuxième à sa droite eu sa tête coupée avant de s'en apercevoir. Les froides piques du gritche traversèrent quatre scientifiques avant que les autres n'ai le temps de comprendre ce qu'il se passait. Il allait vite, mais sa vitesse était encore humaine. Plusieurs laser fusèrent dans sa direction, mais semblèrent ricocher sur le corps de métal. Une roquette fut envoyée dans sa direction, mais le monstre terrifiant se tint, inaltérable, au milieu de la poussière en suspension qu'avait soulevé l'explosion. Il passa alors en mode accéléré, cessant littéralement d'être à son point de départ pour être directement devant sa cible. Trois scientifique s'affalèrent sur le sol en même temps, transpercés à quelques milisecondes seulement d'intervalle par les piques du monstre. Puis ce dernier apparut devant Haeg, celui-ci était terrifié au point de ne plus pouvoir bouger un seul de ses muscles, il hurla vainement au gritche de s'arrêter. Il pouvait pourtant se vanter sans mentir de n'avoir jamais connu la peur, et d'être resté impassible devant des situations périlleuses, mais à cet instant, le regard morbide que lui jetait le gritche l'avait transpercé, apeuré. Il pensa un instant que l'effroyable monstre allait obéir à ses ordres et stopper ici son massacre. Mais ce dernier souleva un de ses sinistres bras, prêt à trancher le scientifique en deux, puis, brusquement, il trembla violemment et s'effondra sur le sol. Haeg reprit le contrôle de ses esprit et regarda le monstre à ses pieds. Autour de lui, le tohu-bohu des cris de terreur des scientifiques paniqués commençait à peine à cesser. Il n'avait pas pu le maîtriser, le soumettre à ses ordres... Pourquoi ? Et pourquoi s'était-il effondré ? 
Des recherches approfondies se déroulèrent plus tard pour répondre à ces deux questions. La première ne trouva aucune réponse. La deuxième, elle, en trouva une. Un monstre capable de tels pouvoirs utilisait tellement d'énergie que le monstre ne pouvait que mourir s'il n'arrivait pas à utiliser ses dons avec parcimonies, et à s'arrêter quand il le fallait. Mais il semblait que cet être sortit tout droit d'un autre temps n'avait aucune idée de ses limites. Le projet fut mis de côté le temps qu'on avance dans les recherches, et d'autres projets furent ouverts. Mais Haeg ne s'estimait pas satisfait.
},
    resume:
%{Haeg est un multimilliardaire borné doublé d'un scientifique très doué. Il ne rechigne pas à faire souffrir des innocents pour satisfaire ses propres besoins ou plaisirs. Torturer un scientifique pour qu'il lui livre des secret n'était que coutume, détail, mais il y prenait un malin plaisir. Son coeur de pierre semble ne ressentir aucune émotion, plus froid que la glace. Plutôt vif et malin, il se débrouille bien dans les discussions d'affaires avec d'autres chefs d'entreprise, mais lorsqu'il s'agit de se battre, il préfère toujours laisser sa garde personnelle le faire à sa place, ou disparaître le plus vite possible lorsque l'ambiance commence à chauffer. Il dispose néanmoins la plupart du temps d'une ou plusieurs armes dernier cri assez discrète pour être cachée sur lui. Il possède une implacable maîtrise de soi et sait rester impassible et calme devant la plupart des situations. Presque tout les gens avec lesquels il lui arrive de parler n'arrivent jamais à discerner son humeur, sa surprise, ou ses sentiments. Il s'amuse de la peur, des bredouillements, et autres claquement de dents de ses employés. Son orgueil frôle la démesure et son air hautain n'a d'égal que ses regards dédaigneux.
},
    small_rp:
%{Ses cheveux noirs coupés courts, coiffés vers l'arrière dévoilent un visage son visage maigre et effilé, jeune et beau. Des sourcils fins et des yeux noirs, capables aussi bien de brûler d'une colère froide et de descendre quelqu'un d'un simple regard que d'exprimer un joie sereine, pleine de charme. Un léger sourire à la frontière entre le sarcasme et l'aimabilité. Plutôt grand, un corps modulé par l'exercice physique. Il porte généralement des vêtements coûteux, pantalon noir, veste noire et chemise blanche, col ouvert sur un torse musclé.
},
    anecdote:
%{Il semblerait qu'il se soit fait construire un laboratoire dans les sous sols d'Aeranpolis, il pense que les plus grands de la ville sont au courant, étant donné qu'ils gardent un oeil sur tout le monde d'en la ville, mais il espère que cela restera secret le plus longtemps possible. Il se sert de ce laboratoire pour efectuer des recherches sur l'ADN et ainsi augmenter les rangs de sa Garde Personnelle de soldats.. Améliorés.
},
    topic: topics[0],
})
febay = Character.create!({
    first_name: "Febay", last_name: "Karston", 
    birth_date: "15/04/1982".to_date,
    birth_place: "Quelque part dans un bled perdu des States", 
    sex: true, 
    avatar_url: "http://i135.photobucket.com/albums/q124/cyb3rpix/spike2copie.png",
    avatar_name: "James Marsters",
    copyright: "D.Svitanir",
    story:
%{Quelqu’un qui se disait « Un homme qui vous veut du bien » avait envoyé une lettre à Febay pour apparemment lui montrer quelque chose qui pourrait l’intéresser. Le cerber venait de lire l’introduction écrite par cet homme. Il grogna, il n’avait pas de temps à perdre. Cet homme lui disait avoir fait quelques recherches sur lui, et avoir trouvé un témoignage de lui-même qui pourrait l’intéresser. Les neurones de très faibles capacité de Febay n’avait pas compris grand-chose au message mais avait saisit le principal : L‘information pouvait s‘avérer importante pour lui, ou par extension pour son organisation, auquel cas il la ferait passer directement à l‘inquisiteur sous les ordres duquel il était. Ce résonnement sonnait pour lui comme une évidence, un chemin obligatoire pour ses pensées. Lui qui de sa vie ne s’était jamais posé de questions sur lui-même commença un peu à se demander s’il avait un « ego ». Ses pensées furent d’un seul coup coupées par un mur invisible. Mais cela ne l’empêcha pas de lire la lettre.
C’était un vieil article de journal découpé. On pouvait voir en haut quelques lignes : 
« …disparition d’un scientifique et de sa…
…fait scandale à Tyral avec son…
…n’a pas voulu répondre à nos… »
Puis venait l’article qui l’intéressait. Entouré avec un feutre rouge. Il ne pouvait pas se tromper.

<blockquote>Alors comme ça vous voulez que je vous raconte ma vie ? Hé bien.. Je dois avouer que c’est quelque chose qui n’est pas fréquent ! La plupart des personnes de mon entourages seraient d’accord pour me dire de me taire dès que j’aurais commencé à parler ! Mais j’en suis flatté ! Vous vous intéressez à moi ? Soit ! Je vais vous donner de quoi satisfaire votre soif de connaissance. Mais ma vie n’a pour l’instant rien d’exceptionnel. Ho non, rien. A part mon incroyable chance dans le choix de mes investissements !… Mais si vous désirez entendre mon « Histoire », il va falloir me promettre de ne pas vous endormir.
Ma vie fut paisible.. Trop à mon goût en fait. 
Je suis né dans un petit village de campagne, voyez-vous, du genre où les événements sortant tout juste légèrement de l’ordinaire se distillent au compte goutte. Les nouvelles du monde arrivaient souvent avec de nombreux mois de retards, une des contrée les plus reculées de l’Amérique quoi. Un truc paumé, perdu entre les plaines, les montagnes et les forêts. J’ai étudié dans une université paisible, où il ne se passait pas plus de choses. Puis j’en ai eu marre et un fois ma majorité atteinte je suis partit à New York. J’y ai trouvé un petit boulot en temps que journaliste pour un « daily » pas trop connu, mais assez intéressant à mon goût. J’ai ensuite investit dans une petite compagnie de programmation… Celle-ci, dans les trois ans qui suivirent, a une connu une expansion considérable. Je me suis vite trouvé à la tête d’un véritable petite fortune. Je suis venu m’installer ici, à Tyral, connue pour son expansion technologique et l’enchaînement presque journalier des découvertes scientifiques… Être là où se passent les choses.. C’est cela qui m’avait toujours intéressé ! Grâce à ce petit investissement qui porte encore aujourd’hui ses fruits, j’ai pu atteindre mon rêve. Tyral, me voici.
James Anderson</blockquote>

Febay n’en croyait pas ses yeux. Ce document était apparemment son témoignage. C’était impossible. Il ne s’en souvenait pas… A moins que… Si… Il lui sembla entrevoir un journaliste perdu dans une grande ville, visitant les kiosques à journaux en espérant trouver un job. Il revit ce même jeune homme entrer dans un riche appartement d’un autre ville.. Une gigantesque baie vitrée donnait devant lui sur la mer. Un voix à l’intérieur de son crâne retentit, cherchant des pensées sur lesquelles s’accrocher pour prendre sur lui un point d’appui. Ses pensèrent se stoppèrent à nouveau. Non. Ce n’était pas lui. L’homme qui lui avait donné ça avait du se trompé, ou avait du tenter de le berner. Febay avait toujours vécu à Tyral. Febay avait toujours obéit aux inquisiteurs depuis sa plus petite enfance. Febay avait été conçu pour obéir. Sa main froissa le papier de journal. Il voulut le jeter à la poubelle sans aucun remords, mais sans vraiment y penser, sa main garda le papier et le mit dans sa poche. Quelques secondes plus tard, il avait oublié ce qui s’était passé. .. Ou presque.
},
    resume:
%{~~~Caractéristiques~~~
Fiche du Cerber n° 16c alias Febay Karston :
Modifié à l’âge de : 23 ans.
Type : Peau-roc.
Sous-type : Résistance aux chocs. 
Sous projets : - Annihilation de la conscience de soi.
- Annihilation de la capacité de raisonnement
- Instauration d’un programme nerveux dans le cerveau contrôlant les pensées et faisant blocages s’elles ne se réfèrent pas à ses règles.
- Résistance aux choc. (Sujet particulièrement difficile à assomer, ou à blesser par contact brutaux.)
- Reconstitution rapide des membres après blessure.
Notes : Échec quasi-total de ce dernier projet.
- Trois premiers projets soumis à conditions. L’expérience peut, avec une émotion trop forte, un souvenir persistant de son ante-annihilation ou un choc émotionnel du à une intervention extérieur, être irrémédiablement dépassée.
Note post-création : La réduction des facultés cérébrales a eu pour effet de muscler son corps svelte, à force d’entraînement pour occupation.
Nom du chef de projet : Information supprimée de la base de donnée. Contactez l’administrateur.
~~~Fin des Caractéristiques~~~
},
    small_rp:
%{Avant : C'était un homme mince, peu musclé, mais pas au point d'en être squelletique. Sa musculature était dans la moyenne. Ses scheveux étaient, et sont encore courts et blancs (mais oui il a 25 ans.. Mais il aime bien le blanc c'est pas sa faute XD). Son visage est assez carré, ses sourcils plutôt épais. Il a un look assez décontracté, blouson de cuir noir ou parfois bleu foncé, jean. Il n'aime pas trop les costumes, quoi qu'il soit parfois obligé d'en mettre pour certaines soirées.
Après : Il n'a presque pas changé après l'expérience au niveau tenue vestimentaire. On remarque néanmoins un grossissement non négligeable de sa masse musculaire, et ses traits se sont un peu affaissé dans une expression impassible montrant son absence quasi-totale de pensées, et donc de sentiments. Un expression d'incompréhension anime souvent ses traits, mais elle est presque toujours remplacée peu après pas l'indifférence, ses neurones abandonnant la partie perdue d'avance.
},
    anecdote:
%{Non obligatoire : Un inquisiteur pourrait peut-être me prendre sous son commandement au début, jusqu’à la révélation du moins, que je tiens à faire en RP (sais pas pourquoi XD). Si quelque un est intéressé, manifestez vous.
},
    topic: topics[1],
})
virus = Character.create!({
    first_name: "Pablo", last_name: "Nerudo", 
    birth_date: "12/12/1982".to_date,
    birth_place: "En Espagne", 
    sex: true, 
    avatar_url: "http://r21.imgfast.net/users/2114/54/74/21/avatars/52-94.jpg",
    avatar_name: "James Marsters",
    copyright: "Juleffel",
    story:
%{« Virus VI... Ayant d'abord atteint des sommets dans la programmation, il s'était ensuite tourné vers le piratage pour y trouver de nouveaux défis. Ayant attaqué avec succès et sans se faire repérer des réseaux surprotégés, entrant et sortant des dossiers de la CIA comme dans un moulin, il avait finit par se mettre à son compte dans un immeuble d'Alfag, au cœur des plus grand réseaux mondiaux. En devanture il proposait ses services pour créer quelques programmes à de grandes sociétés. En arrière boutique, il piratait réseau sur réseau, créant une base de donnée considérable de toutes les informations trouvées combinée sur tout ses PC. À ce jour, personne n'en possédait autant, d'autant plus que sa base s'agrandissait chaque jour. C'était un vieil ami d'Haeg, et ce dernier était le seul à connaître l'existence de ces données. Il l'avait deviné au fil de leur conversations et l'avait finalement poussé à avoué. Mais il ne s'en servait qu'avec parcimonie, de peur que d'autres ne comprennent le trésor qu'il gardait caché. Virus lui ne cherchait pas à utiliser ses trouvailles, seul le défi l'intéressait, et il disait que cela lui suffisait largement. Haeg le suspectait d'attendre son heure, ne pouvant croire à ce pouvoir gardé inutilisé et irrévélé, mais rien dans son comportement ne montrait qu'il ne voulait autre chose. Un jour peut-être parviendrait-il à le convaincre de faire un duo détonnant et de bousculer un peu les pouvoirs en place. »
Ainsi Virus VI est-il décrit par Haeg la première fois qu'il entre dans le RP. Cependant, depuis ce temps, les choses ont changé. Virus VI a rencontré quelques problèmes avec les Ellipsis et doit maintenant sa survie à la protection d'Haeg Ponak qui lui a offert un appartement proche du sien, tout cela en échange de son aide et des ses bases de données, comme dirait Haeg, « L'information, c'est la base du pouvoir ». Désormais, les deux hommes sont régulièrement ensembles « pour affaires », Haeg ayant souvent besoin de lui pour pirater un réseau, ou pour accomplir une tache que seul un homme en qui il a entièrement confiance peut faire. Nul n'ignore désormais cet état de fait, et personne ne se risque à le gêner.
},
    resume:
%{Il est extrêmement intelligent et habile de ses mains, mais seulement pour taper au clavier. L'expression « être né avec un clavier dans les mains » semble avoir été créée pour lui. En effet, depuis tout jeune, il s'intéresse à l'informatique, de sorte qu'il doit être l'informaticien le plus doué au monde à l'époque de Tyral. Capable de pirater n'importe quel réseau, de créer n'importe quel programme, voilà votre homme. En plus de ses tares physiques, il est peureux, lâche, pas habile au combat rapproché, timide, introverti. Cependant, c'est un excellent sniper. Il déteste l'alcool, il n'est pas intéressé par les femmes. Il est généralement froid et distant lorsqu'on lui parle. Cependant, on se rend bien vite compte qu'il écoute bel et bien ce que vous dites, car il est impossible de tenter de le berner sans comprendre qu'il a déjà trois tours d'avance. Méfiant de nature, il se pense obligé de tester chaque personne avec laquelle il parle pour savoir si c'est bien celui à qui il veut parler. Il a aussi prit l'habitude de faire sonner le portable de son rendez-vous quelques secondes avant son arrivée, autant pour déstabiliser que pour prévenir la cible.
},
    small_rp:
%{C'est un homme petit et maigre, au teint pâle, et aux vêtements négligés. Son visage est partiellement ridé par la fatigue et le travail. Ses cernes ne le quittent presque jamais. De petites lunettes rectangulaires pendent au bout de son nez, prêtes à tomber au moindre geste brusque. Ses cheveux blonds n'ont apparemment pas été coupés, ni lavés, ni coiffés depuis un bout de temps. Il tremble légèrement, ses longs doigts fins incapables d'arrêter de bouger, et ses jambes paraissent extrêmement frêles. C'est exactement le contraire de l'homme beau et musclé qu'une femme cherche à épouser.
},
    anecdote:
%{Virus VI n'a pas un physique très avantageux, mais son intelligence rattrape un peu le coup. Ses défauts sont nombreux, mais qui sait, peut-être que quelqu'un sera intéressé par ce personnage « différent » du stéréotype des personnages de forum. Pour la partie psychologique, se reporter à la partie portant ce nom ^^
},
    topic: topics[2],
})

# Links
Link.create!([
  {from_character: haeg, to_character: virus, title: "Geek Favoris", 
    description: %{Virus est le pirate informatique préféré d'Haeg, il lui hack tout ce qu'il veut.},
    force: 50}, # force de -100 à 100
  {from_character: virus, to_character: haeg, title: "Tyran", 
    description: %{Virus crains Haeg plus que tout au monde, c'est son pire cauchemard !},
    force: -100},
  {from_character: haeg, to_character: febay, title: "Vieil ennemi", 
    description: %{C'est dans ses plus grands ennemis qu'on reconnait aussi ses plus grands amis},
    force: -20},
])

nodes = Node.create!([
  {latitude: 45, longitude: 2.5, title: "Haeg est parti manger un Kebab.",
    resume: %{Il a croisé presonne.},
    begin_at: "13/12/2013".to_date},
  {latitude: 45.5, longitude: 2.2, title: "Haeg est parti manger un autre Kebab.",
    resume: %{Il a croisé presonne Febay, l'a frappé, est reparti.},
    begin_at: "14/12/2013".to_date,
    topic: topics[3]},
  {latitude: 44.5, longitude: 1.8, title: "Haeg est parti remanger encore un Kebab.",
    resume: %{Febay était plus là.},
    begin_at: "15/12/2013".to_date},
  {latitude: 42, longitude: 2.5, title: "Rien à signaler.",
    resume: %{},
    begin_at: "13/12/2013".to_date},
  {latitude: 15, longitude: 18, title: "Febay est parti se planquer comme un gros lâche.",
    resume: %{Bientôt, la vengeance serait sienne...},
    begin_at: "15/12/2013".to_date},
  {latitude: 0, longitude: 120, title: "Pendant ce temps, Virus fait des sushis.",
    resume: %{},
    begin_at: "15/12/2013".to_date},
])

Presence.create!([
  {node: nodes[0], character: haeg},
  {node: nodes[1], character: haeg},
  {node: nodes[1], character: febay},
  {node: nodes[2], character: haeg},
  {node: nodes[3], character: febay},
  {node: nodes[4], character: febay},
  {node: nodes[5], character: virus},
])