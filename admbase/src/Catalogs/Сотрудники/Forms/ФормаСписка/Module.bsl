////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиСобытийРеквизитов

#КонецОбласти

#Область ОбработчикиСобытийТаблиц

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЭлементыОтбора = ЗагружаемыеФИО.Отбор.Элементы;
	ЭлементыОтбора.Очистить();
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные; 
	
	Если ТекущиеДанные = Неопределено Или ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Владелец = Неопределено;	
	Иначе   
		Владелец = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ЭлементОтбора = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение 	= Владелец;
	
КонецПроцедуры

#КонецОбласти

#Область Команды

#КонецОбласти

#Область СлужебныеПроцедуры

#КонецОбласти