///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Необязательные параметры формы:
//
//    УпрощенныйРежим - Булево - флаг того, что будет отчет будет формироваться в упрощенном виде.
//

#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ФормаНастройкиОтчета.Видимость = Ложь;
	
	ЭтаОбработка = ЭтотОбъект();
	Если ПустаяСтрока(Параметры.АдресОбъекта) Тогда
		ОбъектИсточник = ЭтаОбработка.ИнициализироватьЭтотОбъект(Параметры.НастройкиОбъекта);
	Иначе
		ОбъектИсточник = ЭтаОбработка.ИнициализироватьЭтотОбъект(Параметры.АдресОбъекта) 
	КонецЕсли;
	
	// Корректируем отбор по сценарию узла, имитируем общий отбор.
	Если ОбъектИсточник.ВариантВыгрузки=3 Тогда
		ОбъектИсточник.ВариантВыгрузки = 2;
		
		ОбъектИсточник.КомпоновщикОтбораВсехДокументов = Неопределено;
		ОбъектИсточник.ПериодОтбораВсехДокументов      = Неопределено;
		
		ОбменДаннымиСервер.ЗаполнитьТаблицуЗначений(ОбъектИсточник.ДополнительнаяРегистрация, ОбъектИсточник.ДополнительнаяРегистрацияСценарияУзла);
	КонецЕсли;
	ОбъектИсточник.ДополнительнаяРегистрацияСценарияУзла.Очистить();
		
	ЭтотОбъект(ОбъектИсточник);
	
	Если Не ЗначениеЗаполнено(Объект.УзелИнформационнойБазы) Тогда
		Текст = НСтр("ru = 'Настройка обмена данными не найдена.'");
		ОбменДаннымиСервер.СообщитьОбОшибке(Текст, Отказ);
		Возврат;
	КонецЕсли;
	
	Заголовок = Заголовок + " (" + Объект.УзелИнформационнойБазы + ")";
	БазовоеИмяДляФормы = ЭтаОбработка.БазовоеИмяДляФормы();
	
	Параметры.Свойство("УпрощенныйРежим", УпрощенныйРежим);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьТабличныйДокументКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ПриЗакрытииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыРасшифровки = ПараметрыРасшифровкиПервогоУровня(Расшифровка);
	Если ПараметрыРасшифровки <> Неопределено Тогда
		Если ПараметрыРасшифровки.ИмяМетаданныхОбъектаРегистрации = ПараметрыРасшифровки.ПолноеИмяМетаданных Тогда
			ТипРасшифровки = ТипЗнч(ПараметрыРасшифровки.ОбъектРегистрации);
			
			Если ТипРасшифровки = Тип("Массив") Или ТипРасшифровки = Тип("СписокЗначений") Тогда
				// Расшифровка списка
				ПараметрыРасшифровки.Вставить("НастройкиОбъекта", Объект);
				ПараметрыРасшифровки.Вставить("УпрощенныйРежим", УпрощенныйРежим);
				
				ОткрытьФорму(БазовоеИмяДляФормы + "Форма.СоставВыгрузки", ПараметрыРасшифровки);
				Возврат;
			КонецЕсли;
			
			// Расшифровка объекта
			ПараметрыФормы = Новый Структура("Ключ", ПараметрыРасшифровки.ОбъектРегистрации);
			ОткрытьФорму(ПараметрыРасшифровки.ПолноеИмяМетаданных + ".ФормаОбъекта", ПараметрыФормы);

		ИначеЕсли Не ПустаяСтрока(ПараметрыРасшифровки.ПредставлениеСписка) Тогда
			// Открываем себя же с новыми параметрами.
			ПараметрыРасшифровки.Вставить("НастройкиОбъекта", Объект);
			ПараметрыРасшифровки.Вставить("УпрощенныйРежим", УпрощенныйРежим);
			
			ОткрытьФорму(БазовоеИмяДляФормы + "Форма.СоставВыгрузки", ПараметрыРасшифровки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	СформироватьТабличныйДокументКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОтчета(Команда)
	Элементы.ФормаНастройкиОтчета.Пометка = Не Элементы.ФормаНастройкиОтчета.Пометка;
	Элементы.КомпоновщикНастроекПользовательскиеНастройки.Видимость = Элементы.ФормаНастройкиОтчета.Пометка;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьРезультатВыполненияЗадания()
	
	ЗагрузитьРезультатОтчетаСервер();
	
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	ОтображениеСостояния.Видимость = Ложь;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	
КонецПроцедуры

&НаСервере
Функция ЭтотОбъект(НовыйОбъект=Неопределено)
	Если НовыйОбъект=Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(НовыйОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура СформироватьТабличныйДокументКлиент()
	
	РезультатЗапускаФоновогоЗадания = СформироватьТабличныйДокументСервер();
	
	Если РезультатЗапускаФоновогоЗадания.Статус = "Выполняется" Тогда
		
		ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
		ОтображениеСостояния.Видимость                      = Истина;
		ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
		ОтображениеСостояния.Картинка                       = БиблиотекаКартинок.ДлительнаяОперация48;
		ОтображениеСостояния.Текст                          = НСтр("ru = 'Отчет формируется...'");
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания  = Ложь;
		ПараметрыОжидания.ВыводитьСообщения     = Истина;
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершениеФоновогоЗадания", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатЗапускаФоновогоЗадания, ОповещениеОЗавершении, ПараметрыОжидания);
		
	Иначе
		ПодключитьОбработчикОжидания("ЗагрузитьРезультатОтчетаКлиент", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьТабличныйДокументСервер()
	
	ОстановитьФормированиеОтчета();
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("СтруктураОбработки",  ЭтотОбъект().ЭтотОбъектВСтруктуруДляФонового());
	ПараметрыЗадания.Вставить("ПолноеИмяМетаданных", Параметры.ПолноеИмяМетаданных);
	ПараметрыЗадания.Вставить("Представление",       Параметры.ПредставлениеСписка);
	ПараметрыЗадания.Вставить("УпрощенныйРежим",     УпрощенныйРежим);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = 
		НСтр("ru = 'Формирование отчета по составу данных для отправки при синхронизации'");
	
	РезультатЗапускаФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне(
		"ОбменДаннымиСервер.ИнтерактивноеИзменениеВыгрузки_СформироватьТабличныйДокументПользователя",
		ПараметрыЗадания,
		ПараметрыВыполнения);
	
	ИдентификаторФоновогоЗадания   = РезультатЗапускаФоновогоЗадания.ИдентификаторЗадания;
	АдресРезультатаФоновогоЗадания = РезультатЗапускаФоновогоЗадания.АдресРезультата;
	
	Возврат РезультатЗапускаФоновогоЗадания;
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеФоновогоЗадания(РезультатЗапускаФоновогоЗадания, ДополнительныеПараметры) Экспорт
	
	ЗагрузитьРезультатОтчетаКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультатОтчетаКлиент()
	ОбработатьРезультатВыполненияЗадания();
КонецПроцедуры

&НаСервере
Процедура ОстановитьФормированиеОтчета()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	Если Не ПустаяСтрока(АдресРезультатаФоновогоЗадания) Тогда
		УдалитьИзВременногоХранилища(АдресРезультатаФоновогоЗадания);
	КонецЕсли;
	
	АдресРезультатаФоновогоЗадания = "";
	ИдентификаторФоновогоЗадания = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультатОтчетаСервер()
	
	ДанныеОтчета = Неопределено;
	
	Если Не ПустаяСтрока(АдресРезультатаФоновогоЗадания) Тогда
		ДанныеОтчета = ПолучитьИзВременногоХранилища(АдресРезультатаФоновогоЗадания);
		УдалитьИзВременногоХранилища(АдресРезультатаФоновогоЗадания);
	КонецЕсли;
	
	ОстановитьФормированиеОтчета();
	
	Если ТипЗнч(ДанныеОтчета)<>Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ДанныеОтчета.ТабличныйДокумент;
	ОчиститьРасшифровку();
	
	АдресДанныхРасшифровки = ПоместитьВоВременноеХранилище(ДанныеОтчета.Расшифровка, Новый УникальныйИдентификатор);
	АдресСхемыКомпоновки   = ПоместитьВоВременноеХранилище(ДанныеОтчета.СхемаКомпоновки, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	ОстановитьФормированиеОтчета();
	ОчиститьРасшифровку();
КонецПроцедуры

&НаСервере
Процедура ОчиститьРасшифровку()
	
	Если Не ПустаяСтрока(АдресДанныхРасшифровки) Тогда
		УдалитьИзВременногоХранилища(АдресДанныхРасшифровки);
	КонецЕсли;
	Если Не ПустаяСтрока(АдресСхемыКомпоновки) Тогда
		УдалитьИзВременногоХранилища(АдресСхемыКомпоновки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыРасшифровкиПервогоУровня(Расшифровка)
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(
		АдресДанныхРасшифровки,
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновки));
	
	ПолеИмяМетаданных = Новый ПолеКомпоновкиДанных("ПолноеИмяМетаданных");
	Настройки = ОбработкаРасшифровки.Расшифровать(Расшифровка, ПолеИмяМетаданных);
	
	ПараметрыРасшифровки = Новый Структура("ПолноеИмяМетаданных, ПредставлениеСписка, ОбъектРегистрации, ИмяМетаданныхОбъектаРегистрации");
	АнализГруппыУровняРасшифровки(Настройки.Отбор, ПараметрыРасшифровки);
	
	Если ПустаяСтрока(ПараметрыРасшифровки.ПолноеИмяМетаданных) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыРасшифровки;
КонецФункции

&НаСервере
Процедура АнализГруппыУровняРасшифровки(Отбор, ПараметрыРасшифровки)
	
	ПолеИмяМетаданных = Новый ПолеКомпоновкиДанных("ПолноеИмяМетаданных");
	ПолеПредставление = Новый ПолеКомпоновкиДанных("ПредставлениеСписка");
	ПолеОбъект        = Новый ПолеКомпоновкиДанных("ОбъектРегистрации");
	
	Для Каждого Элемент Из Отбор.Элементы Цикл
		Если ТипЗнч(Элемент)=Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			АнализГруппыУровняРасшифровки(Элемент, ПараметрыРасшифровки);
			
		ИначеЕсли Элемент.ЛевоеЗначение=ПолеИмяМетаданных Тогда
			ПараметрыРасшифровки.ПолноеИмяМетаданных = Элемент.ПравоеЗначение;
			
		ИначеЕсли Элемент.ЛевоеЗначение=ПолеПредставление Тогда
			ПараметрыРасшифровки.ПредставлениеСписка = Элемент.ПравоеЗначение;
			
		ИначеЕсли Элемент.ЛевоеЗначение=ПолеОбъект Тогда
			ОбъектРегистрации = Элемент.ПравоеЗначение;
			ПараметрыРасшифровки.ОбъектРегистрации = ОбъектРегистрации;
			
			Если ТипЗнч(ОбъектРегистрации) = Тип("Массив") И ОбъектРегистрации.Количество()>0 Тогда
				Вариант = ОбъектРегистрации[0];
			ИначеЕсли ТипЗнч(ОбъектРегистрации) = Тип("СписокЗначений") И ОбъектРегистрации.Количество()>0 Тогда
				Вариант = ОбъектРегистрации[0].Значение;
			Иначе
				Вариант = ОбъектРегистрации;
			КонецЕсли;
			
			Мета = Метаданные.НайтиПоТипу(ТипЗнч(Вариант));
			ПараметрыРасшифровки.ИмяМетаданныхОбъектаРегистрации = ?(Мета = Неопределено, Неопределено, Мета.ПолноеИмя());
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
