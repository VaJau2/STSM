# STSM

Планы:

- создать класс character, хранящий имя персонажа и метод анимирования говорения
	добавить вторую пню на сцену и добавить ей этот класс
	добавить всех character на сцене в группу
	
- добавить в диалогах возможность включения анимации говорения персонажа через включение-выключение отдельного спрайта рта
	в диалоге нужно get_nodes_in_group, найти персонажа по имени и врубить ему анимацию

- добавить неписям возможность ходить в точку по скрипту
	лучше сразу через навигацию

- убрать префаб игрока и запрогать начало локации:
	темная комната, на фоне звуки праздника и надпись "нажмите пробел чтобы начать игру"
	после нажатия пробела звонит телефон и начинаются сценарные скрипты с диалогами
- запрогать переходы между сценами через затемнение экрана

- нарисовать Страйкли в броне
- нарисовать и создать вторую сцену с движущимся фургоном с внутренностями и сидящей рядом с коробкой Страйкли в броне
- запрогать анимацию передвижения автомобиля + добавить звуки
- запрогать диалог из диздока и окончание уровня после окончания диалога

- нарисовать локацию с лесом и верхнем уровнем базы
	базу можно нарядить под новый год
- запрогать бегающих зайцев в лесу
- запрогать бегающих лисиц в лесу 
- запрогать бегающих волков в лесу (возможно не агрессивных)
- запрогать летающих ворон в лесу

- запрогать инвентарь в виде клеток и одного активного предмета
- добавить миникарту справа-сверху и запрогать на ней направление к цели
- добавить там обозначение врагов в виде точек
- добавить предмет навигатора в инвентарь и запрогать включение миникарты, только когда навигатор включен

- добавить гранаты в инвентарь как предметы
- запрогать кидание оглушающих гранат 
- оглушение срабатывает на игрока, затемняя экран, если он окажется близко

- нарисовать врагов на основе неписей из феникса + нарядить их в оленей
	если игрок бежит, они замечают его в большом радиусе
	если идет, они замечают его в среднем радиусе
	если крадется, то замечают, только когда игрок оказывается в области видимости

- добавить их на карту и запрогать им патрулирование + преследование игрока по стандарту
- запрогать им лассо при приближении к игроку и геймовер 

- добавить на карту прожекторы с возможностью их выключить через пульт управления рядом

- запрогать тревогу с таймером и периодический триггер врагов поблизости игрока при включенной тревоге
- запрогать возможность прятаться в пропах
	враги смотрят пропы, только если видели, как игрок там прячется

- запланировать дальше