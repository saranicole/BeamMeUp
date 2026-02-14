local strings = {
    -----------------------------------------------------------------------------
    -- INTERFACE
    -----------------------------------------------------------------------------
    ["SI_TELE_UI_TOTAL"] = "Wyniki:",
    ["SI_TELE_UI_GOLD"] = "Oszczędzone złoto:",
    ["SI_TELE_UI_GOLD_ABBR"] = "k",
    ["SI_TELE_UI_GOLD_ABBR2"] = "m",
    ["SI_TELE_UI_TOTAL_PORTS"] = "Ilość podróży:",
    ---------
    --------- Buttons
    ["SI_TELE_UI_BTN_REFRESH_ALL"] = "Odśwież listę",
    ["SI_TELE_UI_BTN_UNLOCK_WS"] = "Odblokuj teleporty w obecnej strefie",
    ["SI_TELE_UI_BTN_FIX_WINDOW"] = "Okno błędów",
    ["SI_TELE_UI_BTN_TOGGLE_ZONE_GUIDE"] = "Przełącz do BeamMeUp",
    ["SI_TELE_UI_BTN_TOGGLE_BMU"] = "Przełącz do Przewodnika",
    ["SI_TELE_UI_BTN_PORT_TO_OWN_HOUSE"] = "Posiadane domy",
    ["SI_TELE_UI_BTN_ANCHOR_ON_MAP"] = "Odepnij / Przypnij na mapie",
    ["SI_TELE_UI_BTN_GUILD_BMU"] = "Gildie BeamMeUp i partnerzy",
    ["SI_TELE_UI_BTN_GUILD_HOUSE_BMU"] = "Odwiedź siedzibę BeamMeUp",
    ["SI_TELE_UI_BTN_PTF_INTEGRATION"] = "\"Port to Friend's House\" Integracja",
    ["SI_TELE_UI_BTN_DUNGEON_FINDER"] = "Areny / Triale / Lochy",
    ["SI_TELE_UI_BTN_TOOLTIP_CONTEXT_MENU"] = "\n|c777777(prawoklik by otworzyć opcje)",
    ---------
    --------- List
    --["SI_TELE_UI_UNRELATED_ITEMS"] = "Innej strefie",
    ["SI_TELE_UI_UNRELATED_QUESTS"] = "Zadania w innej strefie",
    ["SI_TELE_UI_SAME_INSTANCE"] = "Tożsama lokalizacja",
    ["SI_TELE_UI_DIFFERENT_INSTANCE"] = "Inna lokalizacja",
    ["SI_TELE_UI_GROUP_EVENT"] = "Grupowe wydarzenie",
    ---------
    --------- Menu
    ["SI_TELE_UI_FAVORITE_PLAYER"] = "Ulubiony gracz",
    ["SI_TELE_UI_FAVORITE_ZONE"] = "Ulubiona strefa",
    ["SI_TELE_UI_VOTE_TO_LEADER"] = "Głosowanie na lidera",
    ["SI_TELE_UI_RESET_COUNTER_ZONE"] = "Resetuj licznik",
    ["SI_TELE_UI_INVITE_BMU_GUILD"] = "Zaproś do gildii BeamMeUp",
    ["SI_TELE_UI_SHOW_QUEST_MARKER_ON_MAP"] = "Pokaż znacznik zadania",
    ["SI_TELE_UI_RENAME_HOUSE_NICKNAME"] = "Przemianuj dom",
    ["SI_TELE_UI_TOGGLE_HOUSE_NICKNAME"] = "Pokaż nazwy",
    ["SI_TELE_UI_VIEW_MAP_ITEM"] = "Pokaż przedmiot - mapa",
    ["SI_TELE_UI_TOGGLE_ARENAS"] = "Areny Jednoosobowe",
    ["SI_TELE_UI_TOGGLE_GROUP_ARENAS"] = "Areny Grupowe",
    ["SI_TELE_UI_TOGGLE_TRIALS"] = "Triale",
    ["SI_TELE_UI_TOGGLE_ENDLESS_DUNGEONS"] = "Nieskończone lochy",
    ["SI_TELE_UI_TOGGLE_GROUP_DUNGEONS"] = "Lochy",
    ["SI_TELE_UI_TOGGLE_SORT_ACRONYM"] = "Sortuj wg. skrótu",
    ["SI_TELE_UI_DAYS_LEFT"] = "%d dni",
    ["SI_TELE_UI_TOGGLE_UPDATE_NAME"] = "Pokaż nazwę aktualizacji",
    ["SI_TELE_UI_UNLOCK_WAYSHRINES"] = "Automatyczne odkrywanie kapliczek",
    ["SI_TELE_UI_TOOGLE_ZONE_NAME"] = "Pokaż nazwę strefy",
    ["SI_TELE_UI_TOGGLE_SORT_RELEASE"] = "Sortuj wg. daty wydania",
    ["SI_TELE_UI_TOGGLE_ACRONYM"] = "Pokaż akronim",
    ["SI_TELE_UI_TOOGLE_DUNGEON_NAME"] = "Pokaż pełną nazwę",
    ["SI_TELE_UI_TRAVEL_PARENT_ZONE"] = "Port to parent zone",
    ["SI_TELE_UI_SET_PREFERRED_HOUSE"] = "Set as preferred house",
    ["SI_TELE_UI_UNSET_PREFERRED_HOUSE"] = "Unset preferred house",



    -----------------------------------------------------------------------------
    -- CHAT OUTPUTS
    -----------------------------------------------------------------------------
    ["SI_TELE_CHAT_FAVORITE_UNSET"] = "Nie wybrano ulubionego miejsca",
    ["SI_TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL"] = "Gracz jest offline lub ukryty przez ustawione filtry",
    ["SI_TELE_CHAT_NO_FAST_TRAVEL"] = "Nie znaleziono opcji Szybkiej Podróży",
    ["SI_TELE_CHAT_NOT_IN_GROUP"] = "Nie jesteś w grupie",
    ["SI_TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED"] = "Nie ustawiono Głównej Rezydencji!",
    ["SI_TELE_CHAT_GROUP_LEADER_YOURSELF"] = "Jesteś liderem grupy",
    ["SI_TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL"] = "Ilość kapliczek odkrytych w strefie:",
    ["SI_TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED"] = "Następujące kapliczki nadal muszą być osobiście odwiedzone:",
    ["SI_TELE_CHAT_SHARING_FOLLOW_LINK"] = "Przekierowanie do linka...",
    ["SI_TELE_CHAT_AUTO_UNLOCK_CANCELED"] = "Automatyczne odblokowywanie przerwane przez użytkownika.",
    ["SI_TELE_CHAT_AUTO_UNLOCK_SKIP"] = "Błąd szybkiej podróży: pominięto tego gracza.",



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_TOGGLE_DISCOVERY, "Włącz tryb losowego odkrywania kapliczek"),
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "Otwórz BeamMeUp kiedy mapa jest otwarta")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "Kiedy otworzysz mapę, BeamMeUp automatycznie się otworzy, w innym przypadku użyj przycisku na górze mapy po lewej oraz przełącznika w panelu przewodnika po mapie.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "Pokaż każdą strefę tylko raz.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "Pokaż tylko jedno wyszukanie dla każdej strefy.")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "Częstotliwość odblokowywania teleportów (ms)")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "Dopasuj częstotliwość automatycznego odblokowywania teleportów. Dla słabszych komputerów lub by zapobiec możliwym rozłączeniom gry wysoka wartość może być pomocna.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "Odśwież i zresetuj otwierając")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "Odśwież listę wyników każdorazowo przy otwarciu BeamMeUp. Pola do uzupełnienia są puste.")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "Czarna lista")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "Ukryj niedostępne strefy")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "Ukryj strefy takie jak Wirująca Arena, Schronienia banitów i strefy solo.")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "Ukryj strefy PvP")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "Ukryj strefy takie jak Cyrodiil, Cesarskie Miasto oraz Pola Bitewne.")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "Ukryj grupowe lochy i triale")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "Ukryj wszystkie 4-osobowe grupowe lochy, 12-osobowe triale i grupowe lochy w Craglornie. Członkowie grupy w tych strefach wciąż będą pokazywani!")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "Ukryj rezydencje")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "Ukryj wszystkie rezydencje.")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "Utrzymaj BeamMeUp otwarte")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "Kiedy otworzysz BeamMeUp bez mapy, pozostanie tam nawet jeśli się poruszysz lub otworzysz inne okna. Jeśli uzywasz tej opcji, rekomendujemy wyłączyć opcję 'Zamknij BeamMeUp kiedy mapa jest zamknięta'.")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "Pokazuj tylko Regiony/Lądy")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "Pokazuj tylko gówne Regiony jak Deshaan or Summerset.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "Częstotliwość odświeżania")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "Kiedy BeamMeUp jest otwarte, automatyczne odświeżanie listy wyników odbywa się co x sekund. Ustaw wartość na 0 by wyłączyć automatyczne odświeżanie.")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "Aktywuj okno wyszukiwania strefy")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "Aktywuj okno wyszukiwania strefy kiedy BeamMeUp jest otwarty razem z mapą.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "Ukryj Groty")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "Ukryj wszystkie Groty.")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "Ukryj Publiczne Lochy")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "Ukryj wszystkie Publiczne Lochy.")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "Ukryj okienka z nazwami stref")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "Ukryj okienka z nazwami stref, aby zapewnić lepsze sortowanie i szybciej znajdować strefy.")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "Ilość wersów/wyszukań")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "Przez ustawienie ilości widocznych wersów/wyszukań możesz kontrolować całkowitą wysokość dodatku.")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "Opcje zaawansowane")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "Ogólne")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "Wyszukiwanie")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "Automatycznie zamknij mapę i BeamMeUp")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "Zamknij mapę i BeamMeUp po rozpoczęciu procesu podróży.")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "Pokaż ilość graczy na mapę")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "Pokazuje ilość graczy na mapie, do których możesz podróżować. Możesz kliknąć na numer by zobaczyć tych wszystkich graczy.")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "Przesunięcie przycisku w oknie czatu")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "Zmień przesunięcie poziome przycisku w nagłówku czatu, aby uniknąć wizualnych konfliktów z innymi ikonami dodatków.")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "Przeszukuj również imiona postaci")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "Przeszukuj również imiona postaci kiedy szukasz graczy.")
mkstr(SI.TELE_SETTINGS_SORTING, "Sortowanie")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "Wybierz jeden z możliwych rodzajów listy.")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "Drugi język wyszukiwania")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "Możesz wyszukiwać według nazw stref w języku domyślnym i tym drugim języku jednocześnie. Etykietka nazwy strefy wyświetla także nazwę w drugim języku.")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "Powiadomienia o ulubionych graczach online")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "Otrzymasz powiadomienie (wiadomość na środku ekranu), gdy jeden z ulubionych graczy bedzie online.")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "Zamknij BeamMeUp kiedy mapa jest zamknięta")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "Kiedy zamykasz mapę, BeamMeUp również się zamyka.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "Przesunięcie pozycji dokowania mapy w poziomie")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "Możesz dostosować poziome przesunięcie dokowania na mapie.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "Przesunięcie pozycji dokowania mapy w pionie")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "Możesz dostosować pionowe przesunięcie dokowania na mapie.")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "Zresetuj wszystkie liczniki stref")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "Wszystkie liczniki stref będą zresetowane. Sortowanie wg. najczęściej używanych zostaje zresetowane.")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE, "Powiadomienie o statusie offline")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP, "Jeśli ustawisz status offline i chcesz szeptać lub podróżować do kogoś, dostaniesz krótki komunikat na ekranie jako przypomnienie. Tak długo jak jesteś 'offline' nie możesz dostać żadnych szeptanych wiadomości i z nikim nie podzielisz się najbliższą kapliczką (a dzielenie się jest fajne).")
mkstr(SI.TELE_SETTINGS_SCALE, "Skalowanie interfejsu")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "Współczynnik skalowania dla całego interfejsu/okna BeamMeUp. Aby zastosować zmiany konieczne jest przeładowanie.")
mkstr(SI.TELE_SETTINGS_RESET_UI, "Resetuj interfejs")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "Resetuj interfejs BeamMeUp przez ustawienie następujących opcji na domyślne: Skalowanie, Przesunięcie przycisku, Przesunięcie dokowania mapy i pozycje okna. Cały interfejs zostanie zresetowany.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "Powiadomienie o mapie surowców")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "Jeśli wydobywasz surowce z mapy i masz nadal jakieś identyczne mapy (ta sama lokalizacja) w swoim ekwipunku, powiadomienie (wiadomość na środku ekranu) poinformuje Cię o tym.")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "Priorytety")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "Komendy Czatu")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "Możesz wybrać, którzy gracze będą preferowani w opcji szybkiej podróży. Po opuszczeniu lub przyłączeniu się do gildii, odświeżenie jest potrzebne by poprawnie wyświetlić.")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "Pokaż dodatkowy przycisk na mapie")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "Pokaż przycisk z tekstem w górnym lewym rogu mapy świata do otwierania BeamMeUp.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "Odtwarzaj dźwięki")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "Odtwórz dźwięk pokazując powiadomienie.")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "Automatyczne potwierdzenie podróży do kapliczki")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "Wyłącz potwierdzanie podróży do kapliczki oknem dialogowym.")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "Pokaż aktualną strefę zawsze na górze")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "Pokazuj aktualną strefę zawsze na górze listy.")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES, "Ukryj posiadane domy")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP, "Ukryj swoje posiadane domy (teleportacja na zewnątrz) w głównej liście.")
mkstr(SI.TELE_SETTINGS_HEADER_STATS, "Statystyki")
mkstr(SI.TELE_SETTINGS_MOST_PORTED_ZONES, "Najczęściej odwiedzane strefy:")
mkstr(SI.TELE_SETTINGS_INSTALLED_SCINCE, "Zainstalowane co najmniej od:")
mkstr(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING, "Ta opcja jest przypięta do postaci (nie całego konta)!")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION, "Animacja teleportacji")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP, "Pokaż dodatkową animację teleportacji gdy podróżujesz przez BeamMeUp. Kolekcjonerski przedmiot 'Błyskotka Finvira' musi być odblokowany.")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON, "Przycisk w oknie czatu")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP, "Wyświetl przycisk w nagłówku okna czatu, które będzie otwierać BeamMeUp.")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM, "Przesuń i powiększ")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP, "Przesuń i powiększ mapę do celu kiedy klikasz na członka grupy lub konkretną lokację (lochy, domy, itd.).")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT, "Znacznik mapy")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP, "Pokazuje znacznik mapy (punkt zbiórki) jako cel na mapie kiedy klikniesz na członka grupy lub konkretną lokację (lochy, domy, itd.). Biblioteka LibMapPing musi być zainstalowana. Pamiętaj również, że jeśli jesteś liderem grupy Twoje zaznaczenia (punkty zbiórki) są widoczne dla wszystkich członków grupy.")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS, "Pokaż mapy bez graczy i domów")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP, "Pokazuje mapy w głównej liście nawet jeśli nie ma w niej gracza ani domu do którego możesz podróżować. Nadal masz możliwość podróżować za złoto jeżeli odkryto co najmniej jedną kapliczkę na tej mapie.")
mkstr(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP, "Wyświetlana strefa i podstrefy zawsze na górze")
mkstr(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP, "Pokaż aktualnie wyświetlaną na mapie świata strefę oraz jej podstrefy zawsze na górze listy.")
mkstr(SI.TELE_SETTINGS_DEFAULT_TAB, "Default list")
mkstr(SI.TELE_SETTINGS_DEFAULT_TAB_TOOLTIP, "The list that is displayed by default when opening BeamMeUp.")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_OUTPUT, "Chat Output")
mkstr(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL, "Fast travel executions")
mkstr(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP, "Informative chat messages about the initiated fast travels. Error messages are still displayed in the chat.")
mkstr(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL, "Supporting messages")
mkstr(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP, "Further helpful chat messages on various actions of the addon.")
mkstr(SI.TELE_SETTINGS_OUTPUT_UNLOCK, "Automatic discovery results")
mkstr(SI.TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP, "Interim results (discovered wayshrines and XP) and supporting messages of the automatic wayshrine discovery.")
mkstr(SI.TELE_SETTINGS_OUTPUT_DEBUG, "Debug messages")
mkstr(SI.TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP, "Technical messages for troubleshooting. It will spam your chat. Please use only on request for short time!")


-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "Otwórz BeamMeUp")
mkstr(SI.TELE_KEYBINDING_CLOSE_MAIN, "Zamknąć BeamMeUp")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "Mapy skarbów, surowców i wskazówki wizji")
mkstr(SI.TELE_KEYBINDING_REFRESH, "Odśwież listę wyników")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "Odblokuj kapliczki w obecnej strefie")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "Podróż do Głównej Rezydencji")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "Odwiedź siedzibę BeamMeUp")
mkstr(SI.TELE_KEYBINDING_CURRENT_ZONE, "Podróżuj do obecnej strefy")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE, "Podróż na zewnątrz Głównej Rezydencji")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER, "Areny / Triale / Lochy")
mkstr(SI.TELE_KEYBINDING_TRACKED_QUEST, "Podróż do śledzonego zadania")
mkstr(SI.TELE_KEYBINDING_ANY_ZONE, "Losowy teleport")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_FAVORITE, "Wayshrine Favorite")


    -----------------------------------------------------------------------------
    -- DIALOGS | NOTIFICATIONS
    -----------------------------------------------------------------------------
    ["SI_TELE_DIALOG_NO_BMU_GUILD_BODY"] = "Bardzo nam przykro, ale wygląda na to, że na tym serwerze nie ma jeszcze gildii BeamMeUp. \n\nSkontaktuj się z nami za pośrednictwem strony ESOUI i załóż oficjalną gildię BeamMeUp na tym serwerze.",
    ["SI_TELE_DIALOG_INFO_BMU_GUILD_BODY"] = "Witamy i dziękujemy za korzystanie z BeamMeUp. W 2019 r. uruchomiliśmy oficjalne gildie BeamMeUp w celu udostępniania bezpłatnych opcji szybkiej podróży. Wszyscy są mile widziani, żadnych wymagań ani zobowiązań!\n\nPo potwierdzeniu tego okna dialogowego zobaczysz spis gildii BeamMeUp oraz gildii partnerskich. Zapraszamy do przyłączenia się! Możesz również znaleźć te gildie klikając przycisk gildii w lewym górnym rogu.\nWasz zespół BeamMeUp",
    ["SI_TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION"] = "Otrzymasz powiadomienie (komunikat środku ekranu), gdy ulubiony gracz wejdzie do gry.\n\nWłączyć tę funkcję?",
    ["SI_TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION"] = "Jeśli wydobywasz surowce z mapy i masz nadal jakieś identyczne mapy (ta sama lokalizacja) w swoim ekwipunku, powiadomienie (wiadomość na środku ekranu) poinformuje Cię o tym.\n\nWłączyć tę funkcję?",
    ["SI_TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE"] = "Integracja \"Port to Friend's House\"",
    ["SI_TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY"] = "Aby skorzystać z funkcji integracji, zainstaluj dodatek \"Port to Friend's House\". Na liście zobaczysz skonfigurowane domy i siedziby gildii.\n\nCzy chcesz teraz otworzyć stronę z dodatkiem \"Port to Friend's House\"?",
    -- AUTO UNLOCK: Start Dialog
    ["SI_TELE_DIALOG_AUTO_UNLOCK_TITLE"] = "Zacząć automatyczne odblokowanie kapliczek?",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_BODY"] = "Użycie sprawia, że BeamMeUp rozpocznie serię szybkich podróży do wszystkich dostępnych graczy w aktualnej strefie. W ten sposób będziesz automatycznie skakać z jednej kapliczki do następnej by odblokować tak wiele jak to możliwe.",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION"] = "Zapętlone odblokowywanie map...",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1"] = "losowo",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2"] = "wg. ilości nieodkrytych kapliczek",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3"] = "wg. ilości graczy",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION4"] = "wg. nazwy strefy",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION"] = "Umieść wyniki w oknie chatu",
    -- AUTO UNLOCK: Refuse Dialogs
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE"] = "Odblokowanie jest niemożliwe",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY"] = "Wszystkie kapliczki na tej mapie zostały już odblokowane.",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2"] = "Odblokowanie kapliczek nie jest możliwe na tej mapie. Ta funkcja jest dostępna tylko w głównych strefach/lądach.",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3"] = "Niestety, nie ma graczy w strefie, do których można by podróżować.",
    -- AUTO UNLOCK: Process Dialog
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART"] = "Uruchomiono automatyczne odblokowywanie kapliczek...",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY"] = "Nowo odkryte kapliczki:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP"] = "Zdobyte doświadczenie:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS"] = "Postęp:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER"] = "Następna podróż za:",
    -- AUTO UNLOCK: Finish Dialog
    ["SI_TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART"] = "Ukończono automatyczne odblokowywanie kapliczek.",
    -- AUTO UNLOCK: Timeout Dialog
    ["SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE"] = "Zbyt długi czas oczekiwania",
    ["SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY"] = "Przepraszamy, wystąpił nieznany błąd. Automatyczne odblokowywanie zostało przerwane.",
    -- AUTO UNLOCK: Loop Finish Dialog
    ["SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE"] = "Ukończono automatyczne odblokowywanie",
    ["SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY"] = "Nie znaleziono więcej map do odblokowywania. Albo nie ma graczy na tych mapach albo już odkryłeś wszystkie kapliczki.",



    -----------------------------------------------------------------------------
    -- CENTER SCREEN NOTIFICATIONS
    -----------------------------------------------------------------------------
    ["SI_TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD"] = "Uwaga: Masz ustawiony status offline!",
    ["SI_TELE_CENTERSCREEN_OFFLINE_NOTE_BODY"] = "Nikt nie może szeptać lub podróżować do Ciebie!\n|c8c8c8c(Powiadomienie może być wyłączone w ustawieniach BeamMeUp)",
    ["SI_TELE_CENTERSCREEN_SURVEY_MAPS"] = "Nadal masz %d taką mapę/mapy badawcze! Wróć tu za chwilę!",
    ["SI_TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE"] = "jest teraz online!",



    -----------------------------------------------------------------------------
    -- ITEM NAMES (PART OF IT) - BACKUP
    -----------------------------------------------------------------------------
    ["SI_CONSTANT_TREASURE_MAP"] = "mapa skarbu", -- need a part of the item name that is in every treasure map item the same no matter which zone
    ["SI_CONSTANT_SURVEY_MAP"] = "survey:", -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft

    -----------------------------------------------------------------------------
    -- LibScrollableMenu - Context menu strings --INS260127 Baertram
    -----------------------------------------------------------------------------
    ["SI_CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL"] = "Toggle all submenu entries ON/OFF", --todo 260127
}

local overrideStr = SafeAddString --do not overwrite with ZO_AddString, but just create a new version to override the exiitng ones created with ZO_CreateStringId!
for k, v in pairs(strings) do
    overrideStr(_G[k], v, 2)
end