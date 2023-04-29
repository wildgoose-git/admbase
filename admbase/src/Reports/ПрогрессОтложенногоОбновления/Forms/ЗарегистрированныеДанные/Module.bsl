///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИмяОбработчика = Параметры.ИмяОбработчика;
	Если Не ЗначениеЗаполнено(ИмяОбработчика) Тогда
		ВызватьИсключение НСтр("ru = 'Не передано имя обработчика.'");
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Зарегистрированные данные по обработчику %1'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок, ИмяОбработчика);
	
	ТекстСводнаяИнформация = НСтр("ru = 'Осталось обработать объектов %1 из %2, прогресс - %3%. За указанный период обработано %4.'");
	Если Не ЗначениеЗаполнено(Число(Параметры.ОбработаноЗаПериод)) Тогда
		ТекстСводнаяИнформация = НСтр("ru = 'Осталось обработать объектов %1 из %2, прогресс - %3%. За указанный период нет обработанных данных.'");
	КонецЕсли;
	
	Элементы.НадписьСводнаяИнформация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСводнаяИнформация,
		Параметры.ОсталосьОбработать,
		Параметры.ВсегоОбъектов,
		Параметры.Прогресс,
		Параметры.ОбработаноЗаПериод);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяОбработчика", ИмяОбработчика);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОбработчикиОбновления.ИмяОбработчика КАК ИмяОбработчика,
		|	ОбработчикиОбновления.ОчередьОтложеннойОбработки КАК Очередь,
		|	ОбработчикиОбновления.ОбрабатываемыеДанные КАК ОбрабатываемыеДанные
		|ИЗ
		|	РегистрСведений.ОбработчикиОбновления КАК ОбработчикиОбновления
		|ГДЕ
		|	ОбработчикиОбновления.ИмяОбработчика = &ИмяОбработчика";
	Результат = Запрос.Выполнить().Выгрузить();
	
	ОписаниеОбработчика = Результат[0];
	Очередь = ОписаниеОбработчика.Очередь;
	ОбрабатываемыеДанные = ОписаниеОбработчика.ОбрабатываемыеДанные.Получить();
	Для Каждого ДанныеПоОбъекту Из ОбрабатываемыеДанные.ДанныеОбработчика Цикл
		ПолноеИмяОбъекта = ДанныеПоОбъекту.Ключ;
		Элементы.ИмяТаблицы.СписокВыбора.Добавить(ПолноеИмяОбъекта);
	КонецЦикла;
	
	ИмяТаблицы = Элементы.ИмяТаблицы.СписокВыбора[0].Значение;
	УстановитьЗапросСписка();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяТаблицыПриИзменении(Элемент)
	УстановитьЗапросСписка();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗапросСписка()
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ИмяТаблицы);
	ЭтоСсылочныйОбъект = ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(МетаданныеОбъекта);
	
	Для Каждого ДобавленныйЭлемент Из ДобавленныеЭлементы Цикл
		Элемент = Элементы.Найти(ДобавленныйЭлемент.Значение);
		Элементы.Удалить(Элемент);
	КонецЦикла;
	
	ДобавленныеЭлементы.Очистить();
	
	ШаблонЗапроса =
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	&ИмяТаблицы КАК ТаблицаИзменения
		|ГДЕ
		|	ТаблицаИзменения.Узел = &Узел";
	ИмяТаблицыИзменения = ИмяТаблицы + ".Изменения";
	
	ТекстЗапроса = СтрЗаменить(ШаблонЗапроса, "&ИмяТаблицы", ИмяТаблицыИзменения);
	Узел = ПланыОбмена.ОбновлениеИнформационнойБазы.УзелПоОчереди(Очередь);
	
	Свойства = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	Свойства.ТекстЗапроса = ТекстЗапроса;
	Свойства.ДинамическоеСчитываниеДанных = Истина;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, Свойства);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "Узел", Узел, Истина);
	
	Родитель = Элементы.Список;
	Если Не ЭтоСсылочныйОбъект Тогда
		СтруктураДляПроверки = Новый Структура;
		СтруктураДляПроверки.Вставить("ОсновнойОтбор", Неопределено);
		Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл // ОбъектМетаданныхИзмерение
			ЗаполнитьЗначенияСвойств(СтруктураДляПроверки, Измерение);
			Если СтруктураДляПроверки.ОсновнойОтбор = Неопределено
				Или Не СтруктураДляПроверки.ОсновнойОтбор Тогда
				Продолжить;
			КонецЕсли;
			
			НовыйЭлемент = Элементы.Добавить("Список" + Измерение.Имя, Тип("ПолеФормы"), Родитель);
			НовыйЭлемент.ПутьКДанным = "Список" + "." + Измерение.Имя;
			ДобавленныеЭлементы.Добавить(НовыйЭлемент.Имя);
		КонецЦикла;
		
		Для Каждого СтандартныйРеквизит Из МетаданныеОбъекта.СтандартныеРеквизиты Цикл // ОписаниеСтандартногоРеквизита
			Если СтандартныйРеквизит.Имя = "Регистратор" Тогда
				НовыйЭлемент = Элементы.Добавить("Список" + СтандартныйРеквизит.Имя, Тип("ПолеФормы"), Родитель);
				НовыйЭлемент.ПутьКДанным = "Список" + "." + СтандартныйРеквизит.Имя;
				ДобавленныеЭлементы.Добавить(НовыйЭлемент.Имя);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		НовыйЭлемент = Элементы.Добавить("СписокСсылка", Тип("ПолеФормы"), Родитель);
		НовыйЭлемент.ПутьКДанным = "Список" + "." + "Ссылка";
		ДобавленныеЭлементы.Добавить(НовыйЭлемент.Имя);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти