﻿# language: ru

@IgnoreOnCIMainBuild


Функционал: Загрузить фичу в vanessa-behavior
	Как Разработчик
	Я Хочу чтобы чтобы у меня была возможность загрузить произвольную тестовую фичу в vanessa-behavior c нужным тегом
	Чтобы я мог использовать фильтры
	
	
 

Сценарий: Первый сценарий без тега
	Когда я развернул все ветки дерева VB
	Когда Я запускаю сценарий открытия TestClient или подключаю уже существующий

@TagScenario
Сценарий: Второй сценарий с тегом, а первый без тега
	Когда я развернул все ветки дерева VB




