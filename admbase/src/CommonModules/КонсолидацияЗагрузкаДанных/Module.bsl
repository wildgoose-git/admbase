////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПолучитьИзменненыеСостоянияСотрудниковERP(ДатаСведений,ДанныеФормыКоллекция) Экспорт 
	
	//Перем СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава;
	//@skip-check reading-attribute-from-database
	ТипПодключения = Справочники.УчетныеДанныеПодключений.ERP.ТипПодключения;
	
	Если ТипПодключения = Перечисления.ТипыПодключения.ПодключениеCOM Тогда
		ТаблицаСостояний = ТаблицаСостояний_COMСоединение(ДатаСведений)
	ИначеЕсли ТипПодключения = Перечисления.ТипыПодключения.WebСервис Тогда 
		ТаблицаСостояний = ТаблицаСостояний_WEBСервис(ДатаСведений)
	Иначе
		ТаблицаСостояний = ТаблицаСостояний_ЗапросHTTP(ДатаСведений)
	КонецЕсли;
	
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаСотрудникиПоПолю(ТаблицаСостояний);
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаПоНаменованию(ТаблицаСостояний,"Подразделения","ПодразделенияСтрока");
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаПоНаменованию(ТаблицаСостояний,"Должности","ДолжностьСтрока");
	
	ТаблицаСостояний = СформироватьТаблицуЗагрузкиСостоянийСотрудников(ТаблицаСостояний,КонецДня(ДатаСведений));
	
	ДанныеФормыКоллекция.Загрузить(ТаблицаСостояний);
	
КонецПроцедуры

Процедура ПолучитьДокументыОтклоненийСотрудниковERP(ДатаСведений,ДанныеФормыКоллекция) Экспорт

	//@skip-check reading-attribute-from-database
	ТипПодключения = Справочники.УчетныеДанныеПодключений.ERP.ТипПодключения;
	
	Если ТипПодключения = Перечисления.ТипыПодключения.ПодключениеCOM Тогда
		ТаблицаОтклонений = ТаблицаОтклонений_COMСоединение(ДатаСведений)
	ИначеЕсли ТипПодключения = Перечисления.ТипыПодключения.WebСервис Тогда 
		ТаблицаОтклонений = ТаблицаОтклонений_WEBСервис(ДатаСведений)
	Иначе
		ТаблицаОтклонений = ТаблицаОтклонений_ЗапросHTTP(ДатаСведений)
	КонецЕсли;
	
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаСотрудникиПоПолю(ТаблицаОтклонений);
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаПоНаменованию(ТаблицаОтклонений,"ТипыДокументов","ТипДокументаСтрока");
	
	ТаблицаОтклонений = СформироватьТаблицуОтклонений(ТаблицаОтклонений);
	//
	ДанныеФормыКоллекция.Загрузить(ТаблицаОтклонений);

КонецПроцедуры

Процедура ПолучитьЗаявкиDMC(ДатаСведений,ДанныеФормыКоллекция) Экспорт

	//@skip-check reading-attribute-from-database
	ТипПодключения = Справочники.УчетныеДанныеПодключений.DMC.ТипПодключения;
	
	Если ТипПодключения = Перечисления.ТипыПодключения.ПодключениеCOM Тогда
		ТаблицаЗаявок = ТаблицаЗаявок_COMСоединение(ДатаСведений)
	ИначеЕсли ТипПодключения = Перечисления.ТипыПодключения.WebСервис Тогда 
		ТаблицаЗаявок = ТаблицаЗаявок_WEBСервис(ДатаСведений)
	Иначе
		ТаблицаЗаявок = ТаблицаЗаявок_ЗапросHTTP(ДатаСведений)
	КонецЕсли;
	
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаСотрудникиПоПолю(ТаблицаЗаявок);
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаПоНаменованию(ТаблицаЗаявок,"ПричиныОтсутсвия","ПричинаОтсутствияСтрока");	//
	ТаблицаЗаявок = СформироватьТаблицаЗаявок(ТаблицаЗаявок);
	//
	ДанныеФормыКоллекция.Загрузить(ТаблицаЗаявок);

КонецПроцедуры

Функция ПолучитьТаблицуPERCo(ИсходныеДанныеФормыКоллекция) Экспорт
	//Проверить использоваие и заменить на СформироватьИсходныеДанныеPERCoСМассивомОшибок 20230506
	ИсходнаяТаблица = ИсходныеДанныеФормыКоллекция.Выгрузить();
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаСотрудникиПоПолю(ИсходнаяТаблица);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗначений",ИсходнаяТаблица);
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаЗначений.ФИОСотрудника КАК Наименование,
	|	ТаблицаЗначений.Сотрудник КАК Сотрудник,
	|	ТаблицаЗначений.Дата КАК Дата,
	|	ТаблицаЗначений.Вход КАК Вход,
	|	ТаблицаЗначений.Выход КАК Выход,
	|	ТаблицаЗначений.ДатаВыход КАК ДатаВыход,
	|	ТаблицаЗначений.Присутствие КАК Присутствие
	|ПОМЕСТИТЬ ТаблицаЗначений
	|ИЗ
	|	&ТаблицаЗначений КАК ТаблицаЗначений
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаНаименования.Наименование КАК Наименование,
	|	ТаблицаНаименования.Владелец КАК Ссылка
	|ПОМЕСТИТЬ СправочникСотрудники
	|ИЗ
	|	Справочник.ЗагружаемыеФИОСотрудников КАК ТаблицаНаименования
	|ГДЕ
	|	ТаблицаНаименования.Наименование В
	|			(ВЫБРАТЬ
	|				ТаблицаЗначений.Наименование КАК Наименование
	|			ИЗ
	|				ТаблицаЗначений КАК ТаблицаЗначений)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СправочникСотрудники.Ссылка КАК Сотрудник,
	|	ТаблицаЗначений.Дата КАК Дата,
	|	ТаблицаЗначений.Вход КАК Вход,
	|	ТаблицаЗначений.Выход КАК Выход,
	|	ТаблицаЗначений.ДатаВыход КАК ДатаВыход,
	|	ТаблицаЗначений.Присутствие КАК Присутствие,
	|	ТаблицаЗначений.Наименование КАК Наименование
	|ИЗ
	|	ТаблицаЗначений КАК ТаблицаЗначений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СправочникСотрудники КАК СправочникСотрудники
	|		ПО ТаблицаЗначений.Наименование = СправочникСотрудники.Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаЗначений.Наименование,
	|	ТаблицаЗначений.Дата";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Функция СформироватьИсходныеДанныеPERCoСМассивомОшибок(МассивЗагрузки,МассивОшибок) Экспорт

	//++инициализация, заполнение таблиц
	ИсходнаяТаблица = КонсолидацияОбщегоНазначения.ИнициализироватьТаблицуЗначенийТаблицыЗагрузки();
	Для Каждого ЭлементМассива Из МассивЗагрузки Цикл
		ЗаполнитьЗначенияСвойств(ИсходнаяТаблица.Добавить(),ЭлементМассива);		
	КонецЦикла;
	
	ТаблицаОшибок = КонсолидацияОбщегоНазначения.ИнициализироватьТаблицуЗначенийТаблицыОшибок();
	Для Каждого ЭлементМассива Из МассивОшибок Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаОшибок.Добавить(),ЭлементМассива);		
	КонецЦикла;
	//--инициализация, заполнение таблиц
	
	СправочникиЗагрузкаИзВнешнихИсточниковПолныеПрава.ЗагрузкаСправочникаСотрудникиСТаблицейОшибок(ИсходнаяТаблица,ТаблицаОшибок);
	
	//++заполнение массива ошибок
	МассивОшибок.Очистить();
	Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
		Структура = КонсолидацияКлиентСервер.ИнициализироватьСтруктуруТаблицыОшибок();
		ЗаполнитьЗначенияСвойств(Структура,СтрокаТаблицы);
		МассивОшибок.Добавить(Структура);
	КонецЦикла;
	//--заполнение массива ошибок
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗначений",ИсходнаяТаблица);
	
#Область ТекстЗапроса

	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаЗначений.ФИОСотрудника КАК Наименование,
	|	ТаблицаЗначений.Сотрудник КАК Сотрудник,
	|	ТаблицаЗначений.Дата КАК Дата,
	|	ТаблицаЗначений.Вход КАК Вход,
	|	ТаблицаЗначений.Выход КАК Выход,
	|	ТаблицаЗначений.ДатаВыход КАК ДатаВыход,
	|	ТаблицаЗначений.Присутствие КАК Присутствие
	|ПОМЕСТИТЬ ТаблицаЗначений
	|ИЗ
	|	&ТаблицаЗначений КАК ТаблицаЗначений
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаНаименования.Наименование КАК Наименование,
	|	ТаблицаНаименования.Владелец КАК Ссылка
	|ПОМЕСТИТЬ СправочникСотрудники
	|ИЗ
	|	Справочник.ЗагружаемыеФИОСотрудников КАК ТаблицаНаименования
	|ГДЕ
	|	ТаблицаНаименования.Наименование В
	|			(ВЫБРАТЬ
	|				ТаблицаЗначений.Наименование КАК Наименование
	|			ИЗ
	|				ТаблицаЗначений КАК ТаблицаЗначений)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СправочникСотрудники.Ссылка КАК Сотрудник,
	|	ТаблицаЗначений.Дата КАК Дата,
	|	ТаблицаЗначений.Вход КАК Вход,
	|	ТаблицаЗначений.Выход КАК Выход,
	|	ТаблицаЗначений.ДатаВыход КАК ДатаВыход,
	|	ТаблицаЗначений.Присутствие КАК Присутствие,
	|	ТаблицаЗначений.Наименование КАК Наименование
	|ИЗ
	|	ТаблицаЗначений КАК ТаблицаЗначений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СправочникСотрудники КАК СправочникСотрудники
	|		ПО ТаблицаЗначений.Наименование = СправочникСотрудники.Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаЗначений.Наименование,
	|	ТаблицаЗначений.Дата";
 
#КонецОбласти	
	
	Массив = Новый Массив;

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Структура = КонсолидацияКлиентСервер.ИнициализироватьСтруктуруИсходныхДанных();
		ЗаполнитьЗначенияСвойств(Структура,Выборка);
		Массив.Добавить(Структура);
	КонецЦикла;
	
	Возврат Массив;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СостоянияСотрудников

Функция СформироватьТаблицуЗагрузкиСостоянийСотрудников(ТаблицаЗначений,Период)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗначений",ТаблицаЗначений);
	Запрос.УстановитьПараметр("Период",Период);
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника,
	|	ТаблицаЗначений.ДолжностьСтрока КАК ДолжностьСтрока,
	|	ТаблицаЗначений.ПодразделенияСтрока КАК ПодразделенияСтрока
	|ПОМЕСТИТЬ ТаблицаЗначений
	|ИЗ
	|	&ТаблицаЗначений КАК ТаблицаЗначений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаНаименования.Владелец КАК Ссылка,
	|	ТаблицаНаименования.Наименование КАК Наименование
	|ПОМЕСТИТЬ СправочникСотрудники
	|ИЗ
	|	Справочник.ЗагружаемыеФИОСотрудников КАК ТаблицаНаименования
	|ГДЕ
	|	ТаблицаНаименования.Наименование В
	|		(ВЫБРАТЬ
	|			ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника
	|		ИЗ
	|			ТаблицаЗначений КАК ТаблицаЗначений)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Должности.Ссылка КАК Ссылка,
	|	Должности.Наименование КАК Наименование
	|ПОМЕСТИТЬ СправочникДолжности
	|ИЗ
	|	Справочник.Должности КАК Должности
	|ГДЕ
	|	Должности.Наименование В
	|		(ВЫБРАТЬ
	|			ТаблицаЗначений.ДолжностьСтрока КАК ДолжностьСтрока
	|		ИЗ
	|			ТаблицаЗначений КАК ТаблицаЗначений)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Подразделения.Ссылка КАК Ссылка,
	|	Подразделения.Наименование КАК Наименование
	|ПОМЕСТИТЬ СправочникПодразделения
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения
	|ГДЕ
	|	Подразделения.Наименование В
	|		(ВЫБРАТЬ
	|			ТаблицаЗначений.ПодразделенияСтрока КАК ПодразделенияСтрока
	|		ИЗ
	|			ТаблицаЗначений КАК ТаблицаЗначений)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникСотрудники.Ссылка КАК Сотрудник,
	|	СправочникДолжности.Ссылка КАК Должность,
	|	СправочникПодразделения.Ссылка КАК Подразделение,
	|	СправочникСотрудники.Наименование КАК Наименование
	|ПОМЕСТИТЬ ЗагружаемыеСостояния
	|ИЗ
	|	ТаблицаЗначений КАК ТаблицаЗначений
	|		ЛЕВОЕ СОЕДИНЕНИЕ СправочникСотрудники КАК СправочникСотрудники
	|		ПО ТаблицаЗначений.ФИОСотрудника = СправочникСотрудники.Наименование
	|		ЛЕВОЕ СОЕДИНЕНИЕ СправочникДолжности КАК СправочникДолжности
	|		ПО ТаблицаЗначений.ДолжностьСтрока = СправочникДолжности.Наименование
	|		ЛЕВОЕ СОЕДИНЕНИЕ СправочникПодразделения КАК СправочникПодразделения
	|		ПО ТаблицаЗначений.ПодразделенияСтрока = СправочникПодразделения.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СостояниеСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	|	СостояниеСотрудниковСрезПоследних.Подразделение КАК Подразделение,
	|	СостояниеСотрудниковСрезПоследних.Должность КАК Должность
	|ПОМЕСТИТЬ СуществующиеСостояния
	|ИЗ
	|	РегистрСведений.СостояниеСотрудников.СрезПоследних(&Период,) КАК СостояниеСотрудниковСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗагружаемыеСостояния.Сотрудник КАК Сотрудник,
	|	ЗагружаемыеСостояния.Должность КАК Должность,
	|	ЗагружаемыеСостояния.Подразделение КАК Подразделение,
	|	ЗагружаемыеСостояния.Наименование КАК Наименование
	|ИЗ
	|	ЗагружаемыеСостояния КАК ЗагружаемыеСостояния
	|		ЛЕВОЕ СОЕДИНЕНИЕ СуществующиеСостояния КАК СуществующиеСостояния
	|		ПО ЗагружаемыеСостояния.Сотрудник = СуществующиеСостояния.Сотрудник
	|		И ЗагружаемыеСостояния.Подразделение = СуществующиеСостояния.Подразделение
	|		И ЗагружаемыеСостояния.Должность = СуществующиеСостояния.Должность
	|ГДЕ
	|	СуществующиеСостояния.Сотрудник ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗагружаемыеСостояния.Наименование";

	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // СформироватьТаблицуЗагрузкиСостоянийСотрудников()

Функция ТаблицаСостояний_ЗапросHTTP(ДатаСведений)
	
	ТаблицаСостояний = ИнициализироватьТаблицуСостояний();
	
	ИмяПубликации = "";
	СоединениеHTTP = Справочники.УчетныеДанныеПодключений.ПолучитьСоединениеHTTP(Справочники.УчетныеДанныеПодключений.ERP,ИмяПубликации);
	
	ТекстЗапросаHTTP = СтрШаблон("/%1/hs/root/employees?date=%2",ИмяПубликации,Формат(ДатаСведений,"ДФ=""ггггММдд"""));
	ЗапросHTTP = Новый HTTPЗапрос(ТекстЗапросаHTTP);
	
	ОтветHTTP = СоединениеHTTP.Получить(ЗапросHTTP);

	Если ОтветHTTP.КодСостояния = 200 Тогда
		
		ИменаСвойствДата = Новый Массив;
		ИменаСвойствДата.Добавить("Месяц");
				
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ОтветHTTP.ПолучитьТелоКакСтроку());
		
		Данные = ПрочитатьJSON(ЧтениеJSON,,ИменаСвойствДата,ФорматДатыJSON.ISO);
		
		Для Каждого Выборка Из Данные Цикл
			
			НоваяСтрока = ТаблицаСостояний.Добавить();
			
			НоваяСтрока.ФИОСотрудника 		= Выборка.ФИОСотрудника;
			НоваяСтрока.ДолжностьСтрока 	= Выборка.ДолжностьСтрока;
			НоваяСтрока.ПодразделенияСтрока = Выборка.ПодразделенияСтрока;
	
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТаблицаСостояний;
	
КонецФункции 

Функция ТаблицаСостояний_WEBСервис(ДатаСведений)  
	
	ТаблицаСостояний = ИнициализироватьТаблицуСостояний();

	Прокси = Справочники.УчетныеДанныеПодключений.ПолучитьПроксиСоедиение(Справочники.УчетныеДанныеПодключений.ERP);
	
	Данные = Прокси.EmployeesData(ДатаСведений); 
	
	Для Каждого Выборка Из Данные.RecordslList Цикл
		
		НоваяСтрока = ТаблицаСостояний.Добавить();
		
		НоваяСтрока.ФИОСотрудника 		= Выборка.EmployeeSurname;
		НоваяСтрока.ДолжностьСтрока 	= Выборка.Position;
		НоваяСтрока.ПодразделенияСтрока = Выборка.Subdivision;
		
	КонецЦикла;
	
	Возврат ТаблицаСостояний;
	
КонецФункции // ЗаполнитьТаблицыЗначенийERP_HTTPСоединение()

Функция ТаблицаСостояний_COMСоединение(ДатаСведений)
	
	ТаблицаСостояний = ИнициализироватьТаблицуСостояний();

	Соединение = Справочники.УчетныеДанныеПодключений.ПодключитьсяКбазе(Справочники.УчетныеДанныеПодключений.ERP);
	
	Если Соединение = Неопределено Тогда
		Возврат ТаблицаСостояний
	КонецЕсли;
	
	Запрос = Соединение.NewObject("Запрос");
	
	Запрос.Текст = ТекстЗапросаСведенияОСотрудниках();
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоМесяца(ДатаСведений));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецМесяца(ДатаСведений));
		
	Выборка = Запрос.Выполнить().Выбрать(); 
	Пока Выборка.следующий() цикл
				
		НоваяСтрока = ТаблицаСостояний.Добавить();
		
		НоваяСтрока.ФИОСотрудника 		= Выборка.ФИОСотрудника;
		НоваяСтрока.ДолжностьСтрока 	= Выборка.ДолжностьСтрока;
		НоваяСтрока.ПодразделенияСтрока = Выборка.ПодразделенияСтрока;
		
	КонецЦикла;

	Возврат ТаблицаСостояний;

КонецФункции

Функция ИнициализироватьТаблицуСостояний()

	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	ТаблицаЗначений.Колонки.Добавить("ФИОСотрудника",		Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	ТаблицаЗначений.Колонки.Добавить("ДолжностьСтрока",		Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(150)));
	ТаблицаЗначений.Колонки.Добавить("ПодразделенияСтрока",	Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));

	Возврат ТаблицаЗначений;
	
КонецФункции // ИнициализироватьТаблицуСостояний()

Функция ТекстЗапросаСведенияОСотрудниках()  
	
	Возврат "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДляПодбораСотрудников.Должность КАК Должность,
	|	ДанныеДляПодбораСотрудников.Наименование КАК Наименование,
	|	ЕСТЬNULL(ДанныеДляПодбораСотрудников.Подразделение.Наименование,"""") КАК ПодразделениеНаименование
	|ПОМЕСТИТЬ ДанныеДляПодбора
	|ИЗ
	|	РегистрСведений.ДанныеДляПодбораСотрудников КАК ДанныеДляПодбораСотрудников
	|ГДЕ
	|	ДанныеДляПодбораСотрудников.Организация.ИНН = ""5044046682""
	|	И ДанныеДляПодбораСотрудников.Начало <= &НачалоПериода
	|	И (ДанныеДляПодбораСотрудников.Окончание = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ ДанныеДляПодбораСотрудников.Окончание >= &КонецПериода)
	|	И НЕ ДанныеДляПодбораСотрудников.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
	|	И НЕ ДанныеДляПодбораСотрудников.КоличествоСтавок = 0
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДляПодбора.Наименование КАК ФИОСотрудника,
	|	ЕСТЬNULL(ДанныеДляПодбора.ПодразделениеНаименование,"""") КАК ПодразделенияСтрока,
	|	ЕСТЬNULL(ДанныеДляПодбора.Должность.Наименование,"""") КАК ДолжностьСтрока
	|ИЗ
	|	ДанныеДляПодбора КАК ДанныеДляПодбора
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФИОСотрудника";
	
КонецФункции // ТекстЗапросаСведенияОСотрудниках()

#КонецОбласти

#Область ДокументыОтклонений

Функция ТаблицаОтклонений_ЗапросHTTP(ДатаСведений)
	
	ТаблицаДокументовОтклонений = ИнициализироватьТаблицуОтклонений();
	
	ИмяПубликации = "";
	СоединениеHTTP = Справочники.УчетныеДанныеПодключений.ПолучитьСоединениеHTTP(Справочники.УчетныеДанныеПодключений.ERP,ИмяПубликации);

	  //++ДокументыERPОтклонения
	ТекстЗапросаHTTP = СтрШаблон("/%1/hs/root/doc?date=%2",ИмяПубликации,Формат(ДатаСведений,"ДФ=""ггггММдд"""));
	ЗапросHTTP = Новый HTTPЗапрос(ТекстЗапросаHTTP);
	
	ОтветHTTP = СоединениеHTTP.Получить(ЗапросHTTP);

	Если ОтветHTTP.КодСостояния = 200 Тогда
		
		ИменаСвойствДата = Новый Массив;
		ИменаСвойствДата.Добавить("ДатаДокумента");
		ИменаСвойствДата.Добавить("ДатаНачала");
		ИменаСвойствДата.Добавить("ДатаОкончания");
				
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ОтветHTTP.ПолучитьТелоКакСтроку());
		
		Данные = ПрочитатьJSON(ЧтениеJSON,,ИменаСвойствДата,ФорматДатыJSON.ISO);
		
		Для Каждого Выборка Из Данные Цикл
			
			НоваяСтрока = ТаблицаДокументовОтклонений.Добавить();
			
			НоваяСтрока.ФИОсотрудника 		=  Выборка.ФИОсотрудника;
			НоваяСтрока.ТипДокументаСтрока 	=  Выборка.ТипДокумента;
			
			//НоваяСтрока.СотрудникКод 		=  Выборка.СотрудникКод;
			НоваяСтрока.Номер 				=  Выборка.Номер;
			НоваяСтрока.ДатаДокумента 		=  Выборка.ДатаДокумента;

			НоваяСтрока.ДатаНачала 			=  Выборка.ДатаНачала;
			НоваяСтрока.ДатаОкончания 		=  Выборка.ДатаОкончания;
			
			
		КонецЦикла;
	КонецЕсли;
	//--ДокументыERPОтклонения

	Возврат ТаблицаДокументовОтклонений;

КонецФункции // ТаблицаОтклонений_ЗапросHTTP()

Функция ТаблицаОтклонений_WEBСервис(ДатаСведений)
	
	ТаблицаДокументовОтклонений = ИнициализироватьТаблицуОтклонений();
	
	Прокси = Справочники.УчетныеДанныеПодключений.ПолучитьПроксиСоедиение(Справочники.УчетныеДанныеПодключений.ERP);

	//++ДокументыERPОтклонения
	Данные = Прокси.DocumentsData(ДатаСведений); 
	
	Для Каждого Выборка Из Данные.RecordslList Цикл
		
		НоваяСтрока = ТаблицаДокументовОтклонений.Добавить();
		
		НоваяСтрока.ФИОсотрудника 		=  Выборка.EmployeeSurname;
		НоваяСтрока.ТипДокументаСтрока 	=  Выборка.DocumentType;
		
		НоваяСтрока.Номер 				=  Выборка.Number;
		НоваяСтрока.ДатаДокумента 		=  Выборка.Date;
		
		НоваяСтрока.ДатаНачала 			=  Выборка.StartDate;
		НоваяСтрока.ДатаОкончания 		=  Выборка.EndDate;
		
	КонецЦикла;
	//--ДокументыERPОтклонения
	
	Возврат ТаблицаДокументовОтклонений;
	
КонецФункции // ТаблицаОтклонений_WEBСервис()

Функция ТаблицаОтклонений_COMСоединение(ДатаСведений)

	ТаблицаОтклонений = ИнициализироватьТаблицуОтклонений();

	Соединение = Справочники.УчетныеДанныеПодключений.ПодключитьсяКбазе(Справочники.УчетныеДанныеПодключений.ERP);
	
	Если Соединение = Неопределено Тогда
		Возврат ТаблицаОтклонений
	КонецЕсли;
	
	Запрос = Соединение.NewObject("Запрос");

	Запрос.Текст = ТекстЗапросаОтклонения();

	Запрос.УстановитьПараметр("ДатаНачала", 	НачалоМесяца(ДатаСведений));
	Запрос.УстановитьПараметр("ДатаОкончания", 	КонецМесяца(ДатаСведений));
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	Пока Выборка.следующий() цикл
		
		НоваяСтрока = ТаблицаОтклонений.Добавить();
		НоваяСтрока.ФИОсотрудника 		=  Выборка.ФИОсотрудника;
		НоваяСтрока.ТипДокументаСтрока 		=  Выборка.ТипДокумента;

		НоваяСтрока.Номер 				=  Выборка.Номер;
		НоваяСтрока.ДатаДокумента 		=  Выборка.ДатаДокумента;

		НоваяСтрока.ДатаНачала 			=  Выборка.ДатаНачала;
		НоваяСтрока.ДатаОкончания 		=  Выборка.ДатаОкончания;
		
	КонецЦикла;


КонецФункции // ТаблицаОтклонений_COMСоединение()

Функция ИнициализироватьТаблицуОтклонений()

	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	ТаблицаЗначений.Колонки.Добавить("ФИОСотрудника",		Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	ТаблицаЗначений.Колонки.Добавить("ТипДокументаСтрока",	Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(150)));
	
	ТаблицаЗначений.Колонки.Добавить("Номер",				Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(52)));
	ТаблицаЗначений.Колонки.Добавить("ДатаДокумента",		Новый ОписаниеТипов("Дата"));
	ТаблицаЗначений.Колонки.Добавить("ДатаНачала",			Новый ОписаниеТипов("Дата"));
	ТаблицаЗначений.Колонки.Добавить("ДатаОкончания",		Новый ОписаниеТипов("Дата"));

	Возврат ТаблицаЗначений;


КонецФункции // ИнициализироватьТаблицуОтклонений()

Функция СформироватьТаблицуОтклонений(ТаблицаЗначений)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗначений",ТаблицаЗначений);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника,
	               |	ТаблицаЗначений.ТипДокументаСтрока КАК ТипДокументаСтрока,
	               |	ТаблицаЗначений.Номер КАК Номер,
	               |	ТаблицаЗначений.ДатаДокумента КАК ДатаДокумента,
	               |	ТаблицаЗначений.ДатаНачала КАК ДатаНачала,
	               |	ТаблицаЗначений.ДатаОкончания КАК ДатаОкончания
	               |ПОМЕСТИТЬ ТаблицаЗначений
	               |ИЗ
	               |	&ТаблицаЗначений КАК ТаблицаЗначений
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	ТаблицаНаименования.Владелец КАК Ссылка,
	               |	ТаблицаНаименования.Наименование КАК Наименование
	               |ПОМЕСТИТЬ СправочникСорудники
	               |ИЗ
	               |	Справочник.ЗагружаемыеФИОСотрудников КАК ТаблицаНаименования
	               |ГДЕ
	               |	ТаблицаНаименования.Наименование В
	               |			(ВЫБРАТЬ
	               |				ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника
	               |			ИЗ
	               |				ТаблицаЗначений КАК ТаблицаЗначений)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СправочникСорудники.Ссылка КАК Сотрудник,
	               |	ТипыДокументов.Ссылка КАК ТипДокумента,
	               |	ТаблицаЗначений.Номер КАК Номер,
	               |	ТаблицаЗначений.ДатаДокумента КАК ДатаДокумента,
	               |	ТаблицаЗначений.ДатаНачала КАК ДатаНачала,
	               |	ТаблицаЗначений.ДатаОкончания КАК ДатаОкончания
	               |ИЗ
	               |	ТаблицаЗначений КАК ТаблицаЗначений
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СправочникСорудники КАК СправочникСорудники
	               |		ПО ТаблицаЗначений.ФИОСотрудника = СправочникСорудники.Наименование
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыДокументов КАК ТипыДокументов
	               |		ПО ТаблицаЗначений.ТипДокументаСтрока = ТипыДокументов.Наименование
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТаблицаЗначений.ДатаДокумента,
	               |	ТаблицаЗначений.ФИОСотрудника";

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // СформироватьТаблицуОтклонений()

Функция ТекстЗапросаОтклонения()

	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Сотрудники.Наименование КАК ФИОсотрудника,
	|	ПараметрыПериодовСтажаПФР.Регистратор КАК Регистратор,
	|	ПараметрыПериодовСтажаПФР.Регистратор.Дата КАК ДатаДокумента,
	|	ВЫБОР
	|		КОГДА ПараметрыПериодовСтажаПФР.Начало < &ДатаНачала
	|			ТОГДА &ДатаНачала
	|		ИНАЧЕ ПараметрыПериодовСтажаПФР.Начало
	|	КОНЕЦ КАК ДатаНачала,
	|	ПараметрыПериодовСтажаПФР.Регистратор.Номер КАК НомерДокумента,
	|	ТИПЗНАЧЕНИЯ(ПараметрыПериодовСтажаПФР.Регистратор) КАК ТипДокумента,
	|	ПараметрыПериодовСтажаПФР.Окончание КАК ДатаОкончания
	|ПОМЕСТИТЬ ТаблицаОтклонений
	|ИЗ
	|	РегистрСведений.ПараметрыПериодовСтажаПФР КАК ПараметрыПериодовСтажаПФР
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ПараметрыПериодовСтажаПФР.Сотрудник = Сотрудники.Ссылка
	|ГДЕ
	|	(ПараметрыПериодовСтажаПФР.Начало МЕЖДУ &ДатаНачала И &ДатаОкончания
	|			ИЛИ ПараметрыПериодовСтажаПФР.Окончание МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|	И ТИПЗНАЧЕНИЯ(ПараметрыПериодовСтажаПФР.Регистратор) В (ТИП(Документ.ПрогулНеявка), ТИП(Документ.ОтпускБезСохраненияОплатыСписком), ТИП(Документ.ОтпускБезСохраненияОплаты), ТИП(Документ.Отпуск), ТИП(Документ.БольничныйЛист), ТИП(Документ.Командировка), ТИП(Документ.Отгул), ТИП(Документ.ОтгулСписком), ТИП(Документ.УвольнениеСписком), ТИП(Документ.Увольнение))
	|	И ПараметрыПериодовСтажаПФР.ГоловнаяОрганизация.ИНН = ""5044046682""
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОтклонений.НомерДокумента КАК Номер,
	|	ТаблицаОтклонений.ДатаДокумента КАК ДатаДокумента,
	|	ТаблицаОтклонений.ФИОсотрудника КАК ФИОсотрудника,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаОтклонений.ТипДокумента) КАК ТипДокумента,
	|	ТаблицаОтклонений.ДатаОкончания КАК ДатаОкончания,
	|	ТаблицаОтклонений.ДатаНачала КАК ДатаНачала
	|ИЗ
	|	ТаблицаОтклонений КАК ТаблицаОтклонений
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаНачала" ;
	
КонецФункции // ТекстЗапросаДокументыМесяцERP()

#КонецОбласти

#Область ЗаявкиДокументооборота

Функция ТаблицаЗаявок_ЗапросHTTP(ДатаСведений)
	
	ТаблицаЗаявок = ИнициализироватьТаблицуЗаявок();
	
	ИмяПубликации = "";
	СоединениеHTTP = Справочники.УчетныеДанныеПодключений.ПолучитьСоединениеHTTP(Справочники.УчетныеДанныеПодключений.DMC,ИмяПубликации);

	ТекстЗапросаHTTP = СтрШаблон("/%1/hs/root/claims?date=%2",ИмяПубликации,Формат(ДатаСведений,"ДФ=""ггггММдд"""));
	ЗапросHTTP = Новый HTTPЗапрос(ТекстЗапросаHTTP);
	
	ОтветHTTP = СоединениеHTTP.Получить(ЗапросHTTP);
	
	Если ОтветHTTP.КодСостояния = 200 Тогда
		
		ИменаСвойствДата = Новый Массив;
		ИменаСвойствДата.Добавить("ВремяНачала");
		ИменаСвойствДата.Добавить("ВремяОкончания");
		ИменаСвойствДата.Добавить("ДатаДокумента");
		ИменаСвойствДата.Добавить("ДатаНачала");
		ИменаСвойствДата.Добавить("ДатаОкончания");
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ОтветHTTP.ПолучитьТелоКакСтроку());

		
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("ФИОСотрудника",	"");
		СтруктураСтроки.Вставить("ДатаДокумента",	'00010101');
		СтруктураСтроки.Вставить("ДатаНачала",		'00010101');
		СтруктураСтроки.Вставить("ДатаОкончания",	'00010101');
		СтруктураСтроки.Вставить("ВремяНачала",		'00010101');
		СтруктураСтроки.Вставить("ВремяОкончания",	'00010101');
		СтруктураСтроки.Вставить("Содержание",		"");
		СтруктураСтроки.Вставить("РегистрационныйНомер","");
		СтруктураСтроки.Вставить("ПричинаОтсутствия","");

		// Выполнить чтение поэлементно в цикле.
		Пока ЧтениеJSON.Прочитать() Цикл
			
			//Сообщить("Тип текущего элемента " + Чтение.ТипТекущегоЗначения);
			Если ЧтениеJSON.ТипТекущегоЗначения = ТипЗначенияJSON.ИмяСвойства Тогда 
				
				ИмяСвойства = ЧтениеJSON.ТекущееЗначение;

				Если Не СтруктураСтроки.Свойство(ИмяСвойства) Тогда
					Продолжить;
				КонецЕсли;
				
				Если ИменаСвойствДата.Найти(ИмяСвойства) = Неопределено Тогда 
					СтруктураСтроки[ИмяСвойства] = ВернутьЗначениеСтроки(ЧтениеJSON);
				Иначе
					СтруктураСтроки[ИмяСвойства] = ВернутьЗначениеДаты(ЧтениеJSON);
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЧтениеJSON.ТипТекущегоЗначения = ТипЗначенияJSON.КонецОбъекта Тогда 
				СтруктураСтроки.Вставить("ПричинаОтсутствияСтрока",СтруктураСтроки.ПричинаОтсутствия);
				ЗаполнитьЗначенияСвойств(ТаблицаЗаявок.Добавить(),СтруктураСтроки)
			КонецЕсли;
			
		КонецЦикла;
		
		ЧтениеJSON.Закрыть();
		
	КонецЕсли;
	
	Возврат ТаблицаЗаявок;
	
КонецФункции // ТаблицаОтклонений_ЗапросHTTP()

Функция ВернутьЗначениеДаты(ЧтениеJSON)
	ЧтениеJSON.Прочитать();
	Попытка
		Возврат	ПрочитатьДатуJSON(Формат(ЧтениеJSON.ТекущееЗначение, "ЧГ="), ФорматДатыJSON.ISO);
	Исключение
	  Возврат '00010101';
	КонецПопытки;	
КонецФункции

Функция ВернутьЗначениеСтроки(ЧтениеJSON)
	ЧтениеJSON.Прочитать();
	Возврат ЧтениеJSON.ТекущееЗначение;	
КонецФункции

Функция ТаблицаЗаявок_WEBСервис(ДатаСведений)
	
	ТаблицаЗаявок = ИнициализироватьТаблицуЗаявок();
	
	Прокси = Справочники.УчетныеДанныеПодключений.ПолучитьПроксиСоедиение(Справочники.УчетныеДанныеПодключений.DMC);

	Данные = Прокси.AbsenceRequests(ДатаСведений); 

	Для каждого Выборка Из Данные.RecordsSet Цикл
		
		НоваяСтрока = ТаблицаЗаявок.Добавить();
		
		НоваяСтрока.ФИОСотрудника 			=  Выборка.EmployeeSurname;
		
		НоваяСтрока.ДатаДокумента 			=  Выборка.Date;
		НоваяСтрока.ДатаНачала 				=  Выборка.DateStart;
		НоваяСтрока.ДатаОкончания 			=  Выборка.DateEnd;
		НоваяСтрока.ВремяНачала 			=  Выборка.TimeStart;
		НоваяСтрока.ВремяОкончания 			=  Выборка.TimeEnd;
		НоваяСтрока.Содержание 				=  Выборка.Content;
		НоваяСтрока.РегистрационныйНомер 	=  Выборка.RegistrationNumber;
		НоваяСтрока.ПричинаОтсутствияСтрока =  Выборка.AbsenceReason;
		
	КонецЦикла;

	Возврат ТаблицаЗаявок;
	
КонецФункции // ТаблицаЗаявок_WEBСервис()

Функция ТаблицаЗаявок_COMСоединение(ДатаСведений)

	ТаблицаЗаявок = ИнициализироватьТаблицуЗаявок();

	Соединение = Справочники.УчетныеДанныеПодключений.ПодключитьсяКбазе(Справочники.УчетныеДанныеПодключений.DMC);
	
	Если Соединение = Неопределено Тогда
		Возврат ТаблицаЗаявок
	КонецЕсли;

	Запрос = Соединение.NewObject("Запрос");
	
	Запрос.Текст = Соединение.СервисыТекстыЗапросов.ТекстЗапросаЗаявкиНаОтсутсвие();
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоМесяца(ДатаСведений));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецМесяца(ДатаСведений));
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	Пока Выборка.следующий() Цикл
		
		НоваяСтрока = ТаблицаЗаявок.Добавить();
		
		НоваяСтрока.ФИОСотрудника 			=  Выборка.ФИОСотрудника;
		
		НоваяСтрока.ДатаДокумента 			=  Выборка.ДатаДокумента;
		НоваяСтрока.ДатаНачала 				=  Выборка.ДатаНачала;
		НоваяСтрока.ДатаОкончания 			=  Выборка.ДатаОкончания;
		НоваяСтрока.ВремяНачала 			=  Выборка.ВремяНачала;
		НоваяСтрока.ВремяОкончания 			=  Выборка.ВремяОкончания;
		НоваяСтрока.Содержание 				=  Выборка.Содержание;
		НоваяСтрока.РегистрационныйНомер 	=  Выборка.РегистрационныйНомер;
		НоваяСтрока.ПричинаОтсутствияСтрока =  Выборка.ПричинаОтсутствия;
		
	КонецЦикла;

	Возврат ТаблицаЗаявок;
	
КонецФункции // ТаблицаЗаявок_COMСоединение()

Функция ИнициализироватьТаблицуЗаявок()

	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	ТаблицаЗначений.Колонки.Добавить("ФИОСотрудника",		Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	
	ТаблицаЗначений.Колонки.Добавить("ДатаДокумента",		Новый ОписаниеТипов("Дата"));
	ТаблицаЗначений.Колонки.Добавить("ДатаНачала",			Новый ОписаниеТипов("Дата"));
	ТаблицаЗначений.Колонки.Добавить("ДатаОкончания",		Новый ОписаниеТипов("Дата"));
	ТаблицаЗначений.Колонки.Добавить("ВремяНачала",			Новый ОписаниеТипов("Дата"));
	ТаблицаЗначений.Колонки.Добавить("ВремяОкончания",		Новый ОписаниеТипов("Дата"));
	ТаблицаЗначений.Колонки.Добавить("Содержание",			Новый ОписаниеТипов("Строка"));
	ТаблицаЗначений.Колонки.Добавить("РегистрационныйНомер",	Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(40)));
	ТаблицаЗначений.Колонки.Добавить("ПричинаОтсутствияСтрока",	Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));

	Возврат ТаблицаЗначений;


КонецФункции // ИнициализироватьТаблицуОтклонений()

Функция СформироватьТаблицаЗаявок(ТаблицаЗначений)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗначений",ТаблицаЗначений);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника,
	               |	ТаблицаЗначений.ПричинаОтсутствияСтрока КАК ПричинаОтсутствияСтрока,
	               |	ТаблицаЗначений.РегистрационныйНомер КАК РегистрационныйНомер,
	               |	ТаблицаЗначений.ДатаДокумента КАК ДатаДокумента,
	               |	ТаблицаЗначений.ДатаНачала КАК ДатаНачала,
	               |	ТаблицаЗначений.ДатаОкончания КАК ДатаОкончания,
	               |	ТаблицаЗначений.ВремяНачала КАК ВремяНачала,
	               |	ТаблицаЗначений.ВремяОкончания КАК ВремяОкончания,
	               |	ТаблицаЗначений.Содержание КАК Содержание
	               |ПОМЕСТИТЬ ТаблицаЗначений
	               |ИЗ
	               |	&ТаблицаЗначений КАК ТаблицаЗначений
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ФИОСотрудника
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	ТаблицаНаименования.Владелец КАК Ссылка,
	               |	ТаблицаНаименования.Наименование КАК Наименование
	               |ПОМЕСТИТЬ СправочникСотрудники
	               |ИЗ
	               |	Справочник.ЗагружаемыеФИОСотрудников КАК ТаблицаНаименования
	               |ГДЕ
	               |	ТаблицаНаименования.Наименование В
	               |			(ВЫБРАТЬ
	               |				ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника
	               |			ИЗ
	               |				ТаблицаЗначений КАК ТаблицаЗначений)
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Наименование
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СправочникСотрудники.Ссылка КАК Сотрудник,
	               |	ПричиныОтсутсвия.Ссылка КАК ПричинаОтсутствия,
	               |	ТаблицаЗначений.РегистрационныйНомер КАК РегистрационныйНомер,
	               |	ТаблицаЗначений.ДатаДокумента КАК ДатаДокумента,
	               |	ТаблицаЗначений.ДатаНачала КАК ДатаНачала,
	               |	ТаблицаЗначений.ДатаОкончания КАК ДатаОкончания,
	               |	ТаблицаЗначений.ВремяНачала КАК ВремяНачала,
	               |	ТаблицаЗначений.ВремяОкончания КАК ВремяОкончания,
	               |	ТаблицаЗначений.Содержание КАК Содержание
	               |ИЗ
	               |	ТаблицаЗначений КАК ТаблицаЗначений
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПричиныОтсутсвия КАК ПричиныОтсутсвия
	               |		ПО ТаблицаЗначений.ПричинаОтсутствияСтрока = ПричиныОтсутсвия.Наименование
	               |		ЛЕВОЕ СОЕДИНЕНИЕ СправочникСотрудники КАК СправочникСотрудники
	               |		ПО ТаблицаЗначений.ФИОСотрудника = СправочникСотрудники.Наименование
	               |ГДЕ
	               |	НЕ СправочникСотрудники.Ссылка ЕСТЬ NULL
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТаблицаЗначений.ДатаДокумента,
	               |	ТаблицаЗначений.ФИОСотрудника
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника
	               |ИЗ
	               |	ТаблицаЗначений КАК ТаблицаЗначений
	               |		ЛЕВОЕ СОЕДИНЕНИЕ СправочникСотрудники КАК СправочникСотрудники
	               |		ПО ТаблицаЗначений.ФИОСотрудника = СправочникСотрудники.Наименование
	               |ГДЕ
	               |	СправочникСотрудники.Ссылка ЕСТЬ NULL
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ФИОСотрудника";
	
	Результат = Запрос.ВыполнитьПакет();
	
	Если Не Результат[3].Пустой() Тогда
		
		Массив = Новый Массив;
		Массив.Добавить("Не загружены данные по:");
		Массив.Добавить(СтрСоединить(Результат[3].Выгрузить().ВыгрузитьКолонку("ФИОСотрудника"),"; "));
		
		ОбщегоНазначения.СообщитьПользователю(СтрСоединить(Массив,Символы.ПС));
		
	КонецЕсли;

	Возврат Результат[2].Выгрузить();


КонецФункции // СформироватьТаблицаЗаявок()

#КонецОбласти

#КонецОбласти

#КонецЕсли



