//
//  MapViewModel.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

// MapViewModel.swift
import Combine
import MapKit

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: - Published Properties
    @Published var searchFrom = ""
        @Published var searchTo = ""
        @Published var fromSuggestions: [BusStop] = []
        @Published var toSuggestions: [BusStop] = []
        @Published var selectedFrom: BusStop?
        @Published var selectedTo: BusStop?
        @Published var suggestions: [RouteSuggestion] = []
        @Published var showRouteResults = false
    
        @Published var showRouteDetails = false
        @Published var selectedSuggestion: RouteSuggestion?
        @Published var bsdBusStops: [BusStop] = []
        @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -6.302181134198874 , longitude: 106.65260099440113),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

    @Published var suggestionWidth: CGFloat = 0
        @Published var suggestionOffset: CGFloat = 0
        // MARK: - Private Properties
    
        private let locationManager = CLLocationManager()
        private var allRoutes: [BusRoute] = []
        private let searchCompleter = MKLocalSearchCompleter()
        private var locationSearchResults: [LocationSuggestion] = []

    override init() {
           super.init()
           setupLocationManager()
           setupMockData()
           searchCompleter.delegate = self
           searchCompleter.resultTypes = .pointOfInterest // Include regular locations
       }

    
    private func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to get user location: \(error)")
        }
    
    func swapLocations() {
        let temp = searchFrom
        searchFrom = searchTo
        searchTo = temp

        let tempSelected = selectedFrom
        selectedFrom = selectedTo
        selectedTo = tempSelected
    }

    
    private func setupMockData() {
        // Load your bus stops and routes here
        // Make sure to separate bus stops from regular locations
        bsdBusStops = [
            BusStop(id: "BS01", name: "Intermoda", location: CLLocationCoordinate2D(latitude: -6.319902912486388, longitude: 106.64371452384238), isBusStop: true),
            BusStop(id: "BS02", name: "Cosmo", location: CLLocationCoordinate2D(latitude: -6.312098624472068, longitude: 106.64866097703134), isBusStop: true),
            BusStop(id: "BS03", name: "Verdant View", location: CLLocationCoordinate2D(latitude: -6.3135382058171885, longitude: 106.64862335719445), isBusStop: true),
            BusStop(id: "BS04", name: "Eternity", location: CLLocationCoordinate2D(latitude: -6.314804674128097, longitude: 106.64629166413174), isBusStop: true),
            BusStop(id: "BS05", name: "Simplicity 2", location: CLLocationCoordinate2D(latitude: -6.313048540439234, longitude: 106.6425585810072), isBusStop: true),
            BusStop(id: "BS06", name: "Edutown 1", location: CLLocationCoordinate2D(latitude: -6.3024419386956625, longitude: 106.64175422053961), isBusStop: true),
            BusStop(id: "BS07", name: "Edutown 2", location: CLLocationCoordinate2D(latitude: -6.301401045958158, longitude: 106.64161410520205), isBusStop: true),
            BusStop(id: "BS08", name: "ICE 1", location: CLLocationCoordinate2D(latitude: -6.297305991629695, longitude: 106.63663993540509), isBusStop: true),
            BusStop(id: "BS09", name: "ICE 2", location: CLLocationCoordinate2D(latitude: -6.301798026906297, longitude: 106.63537576609392), isBusStop: true),
            BusStop(id: "BS10", name: "ICE Business Park", location: CLLocationCoordinate2D(latitude: -6.303322716671507, longitude: 106.63447285075002), isBusStop: true),
            BusStop(id: "BS11", name: "ICE 6", location: CLLocationCoordinate2D(latitude: -6.299214743448269, longitude: 106.63501661265211), isBusStop: true),
            BusStop(id: "BS12", name: "ICE 5", location: CLLocationCoordinate2D(latitude: -6.296908022160658, longitude: 106.63614993540504), isBusStop: true),
            BusStop(id: "BS13", name: "GOP 1", location: CLLocationCoordinate2D(latitude: -6.301333338511644, longitude: 106.6491341047173), isBusStop: true),
            BusStop(id: "BS14", name: "SML Plaza", location: CLLocationCoordinate2D(latitude: -6.3018206829147045, longitude: 106.65107827402896), isBusStop: true),
            BusStop(id: "BS15", name: "The Breeze", location: CLLocationCoordinate2D(latitude: -6.301369321397565, longitude: 106.65315717850528), isBusStop: true),
            BusStop(id: "BS16", name: "CBD Timur 1", location: CLLocationCoordinate2D(latitude: -6.302837404339348, longitude: 106.65015285074993), isBusStop: true),
            BusStop(id: "BS17", name: "CBD Timur 2", location: CLLocationCoordinate2D(latitude: -6.301030700563775, longitude: 106.64876966575737), isBusStop: true),
            BusStop(id: "BS18", name: "GOP 2", location: CLLocationCoordinate2D(latitude: -6.301030700563775, longitude: 106.64876966575737), isBusStop: true),
            BusStop(id: "BS19", name: "Nava Park 1", location: CLLocationCoordinate2D(latitude: -6.299573087873732, longitude: 106.64984707200264), isBusStop: true),
            BusStop(id: "BS20", name: "SWA 2", location: CLLocationCoordinate2D(latitude: -6.299630155562472, longitude: 106.66243293720618), isBusStop: true),
            BusStop(id: "BS21", name: "Giant", location: CLLocationCoordinate2D(latitude: -6.299347597253314, longitude: 106.6666351301771), isBusStop: true),
            BusStop(id: "BS22", name: "Eka Hospital 1", location: CLLocationCoordinate2D(latitude: -6.299065485207059, longitude: 106.67031394722062), isBusStop: true),
            BusStop(id: "BS23", name: "Puspita Loka", location: CLLocationCoordinate2D(latitude: -6.295377145696457, longitude: 106.67766489040433), isBusStop: true),
            BusStop(id: "BS24", name: "Polsek Serpong", location: CLLocationCoordinate2D(latitude: -6.29603586772109, longitude: 106.68131227661276), isBusStop: true),
            BusStop(id: "BS25", name: "Ruko Madrid", location: CLLocationCoordinate2D(latitude: -6.30196884684132, longitude: 106.6843857194694), isBusStop: true),
            BusStop(id: "BS26", name: "Pasar Modern Timur", location: CLLocationCoordinate2D(latitude: -6.305348912751656, longitude: 106.68582347971999), isBusStop: true),
            BusStop(id: "BS27", name: "Griya Loka 1", location: CLLocationCoordinate2D(latitude: -6.304835825560039, longitude: 106.68239886809873), isBusStop: true),
            BusStop(id: "BS28", name: "Sektor 1.3", location: CLLocationCoordinate2D(latitude: -6.3057778200200305, longitude: 106.67991191028288), isBusStop: true),
            BusStop(id: "BS29", name: "Griya Loka 2", location: CLLocationCoordinate2D(latitude: -6.304961931657671, longitude: 106.68151702006185), isBusStop: true),
            BusStop(id: "BS30", name: "Santa Ursula 1", location: CLLocationCoordinate2D(latitude: -6.302771931151865, longitude: 106.6846528507499), isBusStop: true),
            BusStop(id: "BS31", name: "Santa Ursula 2", location: CLLocationCoordinate2D(latitude: -6.300150681430886, longitude: 106.68316410471716), isBusStop: true),
            BusStop(id: "BS32", name: "Sentra Onderdil", location: CLLocationCoordinate2D(latitude: -6.296683334763473, longitude: 106.6812441047167), isBusStop: true),
            BusStop(id: "BS33", name: "Autopart", location: CLLocationCoordinate2D(latitude: -6.295531407562985, longitude: 106.67815419672414), isBusStop: true),
            BusStop(id: "BS34", name: "Eka Hospital 2", location: CLLocationCoordinate2D(latitude: -6.299377523498342, longitude: 106.67009430185223), isBusStop: true),
            BusStop(id: "BS35", name: "East Business District", location: CLLocationCoordinate2D(latitude: -6.299293336866941, longitude: 106.6669586814378), isBusStop: true),
            BusStop(id: "BS36", name: "SWA 1", location: CLLocationCoordinate2D(latitude: -6.299345368339194, longitude: 106.6627761735028), isBusStop: true),
            BusStop(id: "BS37", name: "Green Cove", location: CLLocationCoordinate2D(latitude: -6.2993814628841855, longitude: 106.65987993540543), isBusStop: true),
            BusStop(id: "BS38", name: "AEON Mall 1", location: CLLocationCoordinate2D(latitude: -6.303120040327548, longitude: 106.64347755092595), isBusStop: true),
            BusStop(id: "BS39", name: "CBD Barat 2", location: CLLocationCoordinate2D(latitude: -6.302221368040868, longitude: 106.64205317791004), isBusStop: true),
            BusStop(id: "BS40", name: "Simplicity 1", location: CLLocationCoordinate2D(latitude: -6.312784863402183, longitude: 106.64423142592663), isBusStop: true),
            BusStop(id: "BS41", name: "Greenwich Park Office", location: CLLocationCoordinate2D(latitude: -6.276622057947269, longitude: 106.63404), isBusStop: true),
            BusStop(id: "BS42", name: "De Maja", location: CLLocationCoordinate2D(latitude: -6.280957532704141, longitude: 106.63961596488363), isBusStop: true),
            BusStop(id: "BS43", name: "De Heliconia 2", location: CLLocationCoordinate2D(latitude: -6.283308041078943, longitude: 106.64115927116399), isBusStop: true),
            BusStop(id: "BS44", name: "De Nara", location: CLLocationCoordinate2D(latitude: -6.285010028454532, longitude: 106.64400801314942), isBusStop: true),
            BusStop(id: "BS45", name: "De Park 2", location: CLLocationCoordinate2D(latitude: -6.286975378906274, longitude: 106.64901655547753), isBusStop: true),
            BusStop(id: "BS46", name: "Nava Park 2", location: CLLocationCoordinate2D(latitude: -6.290774052160064, longitude: 106.64982436896942), isBusStop: true),
            BusStop(id: "BS47", name: "Giardina", location: CLLocationCoordinate2D(latitude: -6.291448715328519, longitude: 106.64828215809898), isBusStop: true),
            BusStop(id: "BS48", name: "Collinare", location: CLLocationCoordinate2D(latitude: -6.2906680437956, longitude: 106.64538437301604), isBusStop: true),
            BusStop(id: "BS49", name: "Foglio", location: CLLocationCoordinate2D(latitude: -6.293770702497992, longitude: 106.64307050539043), isBusStop: true),
            BusStop(id: "BS50", name: "Studento 2", location: CLLocationCoordinate2D(latitude: -6.295336698270585, longitude: 106.642156093254), isBusStop: true),
            BusStop(id: "BS51", name: "Albera", location: CLLocationCoordinate2D(latitude: -6.296627753866824, longitude: 106.64468911954826), isBusStop: true),
            BusStop(id: "BS52", name: "Foresta 1", location: CLLocationCoordinate2D(latitude: -6.296720702463259, longitude: 106.647792186508), isBusStop: true),
            BusStop(id: "BS53", name: "Simpang Foresta", location: CLLocationCoordinate2D(latitude: -6.299027376515015, longitude: 106.6479729112976), isBusStop: true),
            BusStop(id: "BS54", name: "Allevare", location: CLLocationCoordinate2D(latitude: -6.297092109712094, longitude: 106.64701553315535), isBusStop: true),
            BusStop(id: "BS55", name: "Fiore", location: CLLocationCoordinate2D(latitude: -6.296699551490208, longitude: 106.64459637983225), isBusStop: true),
            BusStop(id: "BS56", name: "Studento 1", location: CLLocationCoordinate2D(latitude: -6.29562483743795, longitude: 106.64207466523365), isBusStop: true),
            BusStop(id: "BS57", name: "Naturale", location: CLLocationCoordinate2D(latitude: -6.293753267157416, longitude: 106.64283525450247), isBusStop: true),
            BusStop(id: "BS58", name: "Fresco", location: CLLocationCoordinate2D(latitude: -6.290917364823557, longitude: 106.64513283298477), isBusStop: true),
            BusStop(id: "BS59", name: "Primavera", location: CLLocationCoordinate2D(latitude: -6.291167379758763, longitude: 106.64836291534402), isBusStop: true),
            BusStop(id: "BS60", name: "Foresta 2", location: CLLocationCoordinate2D(latitude: -6.290166708825742, longitude: 106.64961926711759), isBusStop: true),
            BusStop(id: "BS61", name: "FBL 5", location: CLLocationCoordinate2D(latitude: -6.28803670795394, longitude: 106.64433874198559), isBusStop: true),
            BusStop(id: "BS62", name: "Courts Mega Store", location: CLLocationCoordinate2D(latitude: -6.286230035126002, longitude: 106.63887072883601), isBusStop: true),
            BusStop(id: "BS63", name: "Q BIG 1", location: CLLocationCoordinate2D(latitude: -6.284470858067212, longitude: 106.63834676447388), isBusStop: true),
            BusStop(id: "BS64", name: "Lulu", location: CLLocationCoordinate2D(latitude: -6.2806509823429675, longitude: 106.6363809368485), isBusStop: true),
            BusStop(id: "BS65", name: "Greenwich Park 1", location: CLLocationCoordinate2D(latitude: -6.27722670353427, longitude: 106.63519582664144), isBusStop: true),
            BusStop(id: "BS66", name: "Prestigia", location: CLLocationCoordinate2D(latitude: -6.294574704864883, longitude: 106.63434147612814), isBusStop: true),
            BusStop(id: "BS67", name: "The Mozia 1", location: CLLocationCoordinate2D(latitude: -6.291653845052858, longitude: 106.62850019474901), isBusStop: true),
            BusStop(id: "BS68", name: "Vanya Park", location: CLLocationCoordinate2D(latitude: -6.295320322717712, longitude: 106.62186825923906), isBusStop: true),
            BusStop(id: "BS69", name: "Piazza Mozia", location: CLLocationCoordinate2D(latitude: -6.290512106223089, longitude: 106.62767242455752), isBusStop: true),
            BusStop(id: "BS70", name: "The Mozia 2", location: CLLocationCoordinate2D(latitude: -6.291595339802968, longitude: 106.62865576632026), isBusStop: true),
            BusStop(id: "BS71", name: "Illustria", location: CLLocationCoordinate2D(latitude: -6.294029293630429, longitude: 106.63433876241467), isBusStop: true),
            BusStop(id: "BS72", name: "CBD Barat 2", location: CLLocationCoordinate2D(latitude: -6.3023066800188365, longitude: 106.64210145762934), isBusStop: true),
            BusStop(id: "BS73", name: "Lobby AEON Mall", location: CLLocationCoordinate2D(latitude: -6.303683149161957, longitude: 106.64356012276883), isBusStop: true),
            BusStop(id: "BS74", name: "CBD Utara 3", location: CLLocationCoordinate2D(latitude: -6.2987607030499175, longitude: 106.6433604073996), isBusStop: true),
            BusStop(id: "BS75", name: "CBD Barat 1", location: CLLocationCoordinate2D(latitude: -6.299449375144083, longitude: 106.64191227244648), isBusStop: true),
            BusStop(id: "BS76", name: "AEON Mall 2", location: CLLocationCoordinate2D(latitude: -6.302851368209015, longitude: 106.64431300128254), isBusStop: true),
            BusStop(id: "BS77", name: "Froogy", location: CLLocationCoordinate2D(latitude: -6.29724016790295, longitude: 106.64050719580258), isBusStop: true),
            BusStop(id: "BS78", name: "Gramedia", location: CLLocationCoordinate2D(latitude: -6.291269859841771, longitude: 106.6394645156416), isBusStop: true),
            BusStop(id: "BS79", name: "Icon Centro", location: CLLocationCoordinate2D(latitude: -6.314595375739716, longitude: 106.646253224144), isBusStop: true),
            BusStop(id: "BS80", name: "Horizon Broadway", location: CLLocationCoordinate2D(latitude: -6.313141392686883, longitude: 106.6503970845614), isBusStop: true),
            BusStop(id: "BS81", name: "BSD Extreme Park", location: CLLocationCoordinate2D(latitude: -6.30975136988534, longitude: 106.6537962107912), isBusStop: true),
            BusStop(id: "BS82", name: "Saveria", location: CLLocationCoordinate2D(latitude: -6.307346701354917, longitude: 106.65359854223301), isBusStop: true),
        ]
        allRoutes = [
            BusRoute(id: "R01", name: "Intermoda - Sektor 1.3", stops: [bsdBusStops[0], bsdBusStops[4], bsdBusStops[5], bsdBusStops[6], bsdBusStops[12], bsdBusStops[13], bsdBusStops[14], bsdBusStops[15], bsdBusStops[16], bsdBusStops[18], bsdBusStops[21], bsdBusStops[22], bsdBusStops[23], bsdBusStops[24], bsdBusStops[25], bsdBusStops[26], bsdBusStops[27]], color: BusRoute.routeColor(for: "R01"),
                     departureTimes: generateDepartureTimes()
                 ),
            BusRoute(id: "R02", name: "Sektor 1.3 - Intermoda", stops: [bsdBusStops[27], bsdBusStops[28], bsdBusStops[29], bsdBusStops[30], bsdBusStops[31], bsdBusStops[32], bsdBusStops[33], bsdBusStops[34], bsdBusStops[35], bsdBusStops[14], bsdBusStops[15], bsdBusStops[16], bsdBusStops[39], bsdBusStops[0]], color: BusRoute.routeColor(for: "R02"),
                     departureTimes: generateDepartureTimes()
                 ),
            BusRoute(id: "R03", name: "Greenwich Park - Sektor 1.3", stops: [bsdBusStops[40], bsdBusStops[41], bsdBusStops[42], bsdBusStops[43], bsdBusStops[44], bsdBusStops[46], bsdBusStops[47], bsdBusStops[48], bsdBusStops[49], bsdBusStops[50], bsdBusStops[51], bsdBusStops[12], bsdBusStops[13], bsdBusStops[14], bsdBusStops[15], bsdBusStops[16], bsdBusStops[18], bsdBusStops[21], bsdBusStops[22], bsdBusStops[25], bsdBusStops[26], bsdBusStops[27]], color: BusRoute.routeColor(for: "R03"),
                     departureTimes: generateDepartureTimes()
                 ),
            BusRoute(id: "R04", name: "Sektor 1.3 - Greenwich Park", stops: [bsdBusStops[27], bsdBusStops[28], bsdBusStops[29], bsdBusStops[30], bsdBusStops[31], bsdBusStops[32], bsdBusStops[33], bsdBusStops[34], bsdBusStops[35], bsdBusStops[14], bsdBusStops[15], bsdBusStops[16], bsdBusStops[52], bsdBusStops[53], bsdBusStops[54], bsdBusStops[55], bsdBusStops[56], bsdBusStops[57], bsdBusStops[58], bsdBusStops[61], bsdBusStops[62], bsdBusStops[63], bsdBusStops[64], bsdBusStops[40]], color: BusRoute.routeColor(for: "R04"),
                     departureTimes: generateDepartureTimes()
                 ),
            BusRoute(id: "R05", name: "Intermoda - De Park (Rute 1)", stops: [bsdBusStops[0], bsdBusStops[4], bsdBusStops[5], bsdBusStops[6], bsdBusStops[7], bsdBusStops[11], bsdBusStops[76], bsdBusStops[77], bsdBusStops[61], bsdBusStops[62], bsdBusStops[63], bsdBusStops[64], bsdBusStops[40], bsdBusStops[41], bsdBusStops[42], bsdBusStops[43], bsdBusStops[44]], color: BusRoute.routeColor(for: "R05"),
                     departureTimes: generateDepartureTimes()
                 ),
            BusRoute(id: "R06", name: "Intermoda - De Park (Rute 2)", stops: [bsdBusStops[0], bsdBusStops[78], bsdBusStops[79], bsdBusStops[80], bsdBusStops[81], bsdBusStops[13], bsdBusStops[14], bsdBusStops[15], bsdBusStops[37], bsdBusStops[75], bsdBusStops[16], bsdBusStops[52], bsdBusStops[53], bsdBusStops[54], bsdBusStops[55], bsdBusStops[56], bsdBusStops[57], bsdBusStops[58], bsdBusStops[59], bsdBusStops[44]], color: BusRoute.routeColor(for: "R06"),
                     departureTimes: generateDepartureTimes()
                 ),
            BusRoute(id: "R07", name: "The Breeze - AEON - ICE - The Breeze", stops: [bsdBusStops[14], bsdBusStops[15], bsdBusStops[16], bsdBusStops[73], bsdBusStops[74], bsdBusStops[71], bsdBusStops[37], bsdBusStops[75], bsdBusStops[73], bsdBusStops[9], bsdBusStops[11], bsdBusStops[74], bsdBusStops[71], bsdBusStops[37], bsdBusStops[75], bsdBusStops[16], bsdBusStops[18], bsdBusStops[36], bsdBusStops[14]], color: BusRoute.routeColor(for: "R05"),
                     departureTimes: generateDepartureTimes()
                 ),
            BusRoute(id: "R08", name: "Intermoda - Vanya Park - Intermoda", stops: [bsdBusStops[0], bsdBusStops[2], bsdBusStops[3], bsdBusStops[4], bsdBusStops[47], bsdBusStops[48], bsdBusStops[49], bsdBusStops[50], bsdBusStops[66], bsdBusStops[44], bsdBusStops[45], bsdBusStops[46], bsdBusStops[67], bsdBusStops[68], bsdBusStops[69], bsdBusStops[70], bsdBusStops[71], bsdBusStops[5], bsdBusStops[6], bsdBusStops[7], bsdBusStops[72], bsdBusStops[73], bsdBusStops[54], bsdBusStops[74], bsdBusStops[8], bsdBusStops[55], bsdBusStops[56], bsdBusStops[60], bsdBusStops[61], bsdBusStops[62], bsdBusStops[1], bsdBusStops[0]], color: BusRoute.routeColor(for: "R06"),
                     departureTimes: generateDepartureTimes()
                 ),
        ]
    }
    
    
    func findDirectRoutes(from: BusStop, to: BusStop) -> [RouteSuggestion] {
        var suggestions: [RouteSuggestion] = []
        
        for route in allRoutes {
            if let fromIndex = route.stops.firstIndex(of: from),
               let toIndex = route.stops.firstIndex(of: to),
               fromIndex < toIndex {
                let duration = Int(calculateDistance(from: from.location, to: to.location) / 333.33)
                suggestions.append(RouteSuggestion(
                    routes: [route],
                    totalDuration: duration,
                    transitCount: 0,
                    departureTime: generateNextDepartureTime()
                ))
            }
        }
        return suggestions
    }
    
    private func nextDepartureTime(for route: BusRoute) -> String {
        guard let firstTime = route.departureTimes.first else {
            return generateNextDepartureTime()
        }
        return firstTime
    }
    
    func findTransferRoutes(from: BusStop, to: BusStop) -> [RouteSuggestion] {
        var suggestions: [RouteSuggestion] = []
        
        // Find routes that contain the "from" stop
        let fromRoutes = allRoutes.filter { $0.stops.contains(from) }
        
        // Find routes that contain the "to" stop
        let toRoutes = allRoutes.filter { $0.stops.contains(to) }
        
        for fromRoute in fromRoutes {
            for toRoute in toRoutes {
                // Find transfer stops (stops that appear in both routes)
                let transferStops = Set(fromRoute.stops).intersection(Set(toRoute.stops))
                
                for transferStop in transferStops {
                    if let fromIndex = fromRoute.stops.firstIndex(of: from),
                       let transferIndex1 = fromRoute.stops.firstIndex(of: transferStop),
                       let transferIndex2 = toRoute.stops.firstIndex(of: transferStop),
                       let toIndex = toRoute.stops.firstIndex(of: to),
                       fromIndex < transferIndex1 && transferIndex2 < toIndex {
                        
                        let duration = Int(
                            (calculateDistance(from: from.location, to: transferStop.location) +
                             calculateDistance(from: transferStop.location, to: to.location)
                            ) / 333.33
                        )
                        
                        suggestions.append(RouteSuggestion(
                            routes: [fromRoute, toRoute],
                            totalDuration: duration,
                            transitCount: 1,
                            departureTime: generateNextDepartureTime()
                        ))
                    }
                }
            }
        }
        return suggestions
    }

    func calculateRoutes() {
        guard let from = selectedFrom, let to = selectedTo else { return }
        
        var suggestions: [RouteSuggestion] = []
        let maxWalkingDistance: Double = 500 // 500 meters
        
        // Get actual coordinates for locations
        let fromLocation = from.location
        let toLocation = to.location
        
        // Find nearest bus stops using coordinate distances
        let fromNearbyStops = bsdBusStops.filter {
            fromLocation.distance(to: $0.location) <= maxWalkingDistance
        }.sorted {
            fromLocation.distance(to: $0.location) < fromLocation.distance(to: $1.location)
        }
        
        let toNearbyStops = bsdBusStops.filter {
            toLocation.distance(to: $0.location) <= maxWalkingDistance
        }.sorted {
            toLocation.distance(to: $0.location) < toLocation.distance(to: $1.location)
        }
        
        // Case 1: Direct bus-to-bus route
        if from.isBusStop && to.isBusStop {
            suggestions.append(contentsOf: findDirectRoutes(from: from, to: to))
            suggestions.append(contentsOf: findTransferRoutes(from: from, to: to))
        }
        // Case 2: Handle location-to-location with walks
        else {
            for fromStop in fromNearbyStops.prefix(3) {
                for toStop in toNearbyStops.prefix(3) {
                    // Get bus routes between stops
                    let busRoutes = findDirectRoutes(from: fromStop, to: toStop)
                    let transferRoutes = findTransferRoutes(from: fromStop, to: toStop)
                    
                    for route in busRoutes + transferRoutes {
                        var fullRoute = route
                        let walkFromDistance = fromLocation.distance(to: fromStop.location)
                        let walkToDistance = toLocation.distance(to: toStop.location)
                        
                        // Add walking segments
                        if !from.isBusStop {
                            let walkTime = Int(walkFromDistance / 83.33) // 5 km/h walking speed
                            fullRoute = RouteSuggestion(
                                routes: [createWalkingRoute(
                                    from: from,
                                    to: fromStop,
                                    distance: walkFromDistance
                                )] + fullRoute.routes,
                                totalDuration: walkTime + fullRoute.totalDuration,
                                transitCount: fullRoute.transitCount,
                                departureTime: fullRoute.departureTime
                            )
                        }
                        
                        if !to.isBusStop {
                            let walkTime = Int(walkToDistance / 83.33)
                            fullRoute = RouteSuggestion(
                                routes: fullRoute.routes + [createWalkingRoute(
                                    from: toStop,
                                    to: to,
                                    distance: walkToDistance
                                )],
                                totalDuration: fullRoute.totalDuration + walkTime,
                                transitCount: fullRoute.transitCount,
                                departureTime: fullRoute.departureTime
                            )
                        }
                        
                        suggestions.append(fullRoute)
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.suggestions = suggestions.sorted { $0.totalDuration < $1.totalDuration }
            self.showRouteResults = true
        }
    }

    private func createWalkingRoute(from: BusStop, to: BusStop, distance: Double) -> BusRoute {
        BusRoute(
            id: "walk-\(UUID().uuidString)",
            name: "Walk \(Int(distance))m from \(from.name) to \(to.name)",
            stops: [from, to],
            color: .gray,
            departureTimes: ["Immediate"]
        )
    }

    // Helper functions
    private func findAccessibleStops(for point: BusStop, maxDistance: Double) -> [(stop: BusStop, distance: Double)] {
        guard !point.isBusStop else { return [(point, 0)] }
        
        return bsdBusStops.compactMap { stop in
            let distance = calculateDistance(from: point.location, to: stop.location)
            return distance <= maxDistance ? (stop, distance) : nil
        }
    }

    private func createWalkingSegment(from: BusStop, to: BusStop, distance: Double) -> RouteSuggestion {
        let walkTime = Int(distance / 1.3889) // 5 km/h walking speed
        return RouteSuggestion(
            routes: [BusRoute(
                id: "walk-\(UUID().uuidString)",
                name: "Walk \(Int(distance))m to \(to.name)",
                stops: [from, to],
                color: .gray,
                departureTimes: []
            )],
            totalDuration: walkTime,
            transitCount: 0,
            departureTime: "Immediate"
        )
    }

    private func addSegmentToRoute(segment: RouteSuggestion, to route: RouteSuggestion) -> RouteSuggestion {
        return RouteSuggestion(
            routes: segment.routes + route.routes,
            totalDuration: segment.totalDuration + route.totalDuration,
            transitCount: route.transitCount,
            departureTime: route.departureTime
        )
    }

    // Enhanced route finding
    private func findDirectBusRoutes(from: BusStop, to: BusStop) -> [RouteSuggestion] {
        return allRoutes.compactMap { route in
            guard let fromIdx = route.stops.firstIndex(of: from),
                  let toIdx = route.stops.firstIndex(of: to),
                  fromIdx < toIdx else { return nil }
            
            let duration = calculateRouteDuration(route: route, fromIdx: fromIdx, toIdx: toIdx)
            return RouteSuggestion(
                routes: [route],
                totalDuration: duration,
                transitCount: 0,
                departureTime: nextDepartureTime(for: route)
            )
        }
    }

    private func calculateRouteDuration(route: BusRoute, fromIdx: Int, toIdx: Int) -> Int {
        let stopCount = toIdx - fromIdx
        let baseDuration = stopCount * 2 // 2 minutes per stop
        let distance = (fromIdx..<toIdx).reduce(0.0) { sum, idx in
            sum + calculateDistance(
                from: route.stops[idx].location,
                to: route.stops[idx+1].location
            )
        }
        return baseDuration + Int(distance / 400) // 24 km/h bus speed
    }
    
    private func createDirectBusRoute(from: BusStop, to: BusStop) -> RouteSuggestion {
        let route = BusRoute(
            id: "R01",
            name: "\(from.name) → \(to.name)",
            stops: [from, to],
            color: BusRoute.routeColor(for: "R01"),
            departureTimes: generateDepartureTimes()
        )
        
        let duration = Int(calculateDistance(from: from.location, to: to.location) / 400) // Bus speed ~24km/h
        
        return RouteSuggestion(
            routes: [route],
            totalDuration: duration,
            transitCount: 0,
            departureTime: generateNextDepartureTime()
        )
    }

    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
    private func findNearbyBusStops(for location: CLLocationCoordinate2D) -> [BusStop] {
        return bsdBusStops.filter { busStop in
            let distance = calculateDistance(from: location, to: busStop.location)
            return distance <= 500 // Within 500m
        }
    }
    
    private func calculateDuration(route: BusRoute, from: BusStop, to: BusStop) -> Int {
            guard let fromIndex = route.stops.firstIndex(where: { $0.id == from.id }),
                  let toIndex = route.stops.firstIndex(where: { $0.id == to.id }) else {
                return 0
            }
            return abs(toIndex - fromIndex) * 2 // 2 minutes per stop
        }
        
    private func calculateDuration(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Int {
        let distance = calculateDistance(from: from, to: to)
        let averageSpeedInMetersPerMinute = 400 // About 24 km/h
        return Int(distance / Double(averageSpeedInMetersPerMinute))
    }

    func generateDepartureTimes() -> [String] {
        let calendar = Calendar.current
        let now = Date()
        var times: [String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        // Generate next 5 departures, each 15 minutes apart
        for i in 0..<5 {
            if let departureTime = calendar.date(byAdding: .minute, value: 15 * i, to: now) {
                times.append(formatter.string(from: departureTime))
            }
        }
        
        return times
    }

    private func generateNextDepartureTime() -> String {
        let calendar = Calendar.current
        let now = Date()
        let nextFiveMinutes = calendar.date(byAdding: .minute, value: 5, to: now) ?? now
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: nextFiveMinutes)
    }
    func searchSuggestions(for query: String, isFrom: Bool) {
            guard !query.isEmpty else {
                if isFrom {
                    fromSuggestions = []
                } else {
                    toSuggestions = []
                }
                return
            }
            
            // Search bus stops
            let filteredBusStops = bsdBusStops.filter {
                $0.name.localizedCaseInsensitiveContains(query)
            }
            
            // Search locations using MKLocalSearchCompleter
            searchCompleter.queryFragment = query
            
            DispatchQueue.main.async {
                if isFrom {
                    self.fromSuggestions = filteredBusStops + self.locationSearchResults.map { $0.asBusStop }
                } else {
                    self.toSuggestions = filteredBusStops + self.locationSearchResults.map { $0.asBusStop }
                }
            }
        }
        
        // New method to handle location selection
        func selectLocation(_ location: BusStop, isFrom: Bool) {
            if location.isBusStop {
                // Direct bus stop selection
                if isFrom {
                    selectedFrom = location
                } else {
                    selectedTo = location
                }
            } else {
                // Resolve coordinates for regular location
                resolveCoordinates(for: location) { coordinate in
                    guard let coordinate else { return }
                    
                    let updatedLocation = BusStop(
                        id: location.id,
                        name: location.name,
                        location: coordinate,
                        isBusStop: false
                    )
                    
                    DispatchQueue.main.async {
                        if isFrom {
                            self.selectedFrom = updatedLocation
                        } else {
                            self.selectedTo = updatedLocation
                        }
                    }
                }
            }
        }
        
        private func resolveCoordinates(for location: BusStop, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location.name
            request.region = region
            
            MKLocalSearch(request: request).start { response, _ in
                completion(response?.mapItems.first?.placemark.coordinate)
            }
        }

}

struct LocationSuggestion {
    let id: String
    let title: String
    let subtitle: String
    var coordinate: CLLocationCoordinate2D?
    
    var asBusStop: BusStop {
        BusStop(
            id: id,
            name: "\(title), \(subtitle)",
            location: coordinate ?? CLLocationCoordinate2D(),
            isBusStop: false
        )
    }
}

extension MapViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let group = DispatchGroup()
        var locationResults = [BusStop]()
        
        for result in completer.results {
            group.enter()
            getCoordinates(for: result) { coordinate in
                defer { group.leave() }
                guard let coordinate else { return }
                
                locationResults.append(BusStop(
                    id: UUID().uuidString,
                    name: result.title,
                    location: coordinate,
                    isBusStop: false
                ))
            }
        }
        
        group.notify(queue: .main) {
            // Combine with bus stop suggestions
            let busStopResults = self.bsdBusStops.filter {
                $0.name.localizedCaseInsensitiveContains(self.searchFrom) ||
                $0.name.localizedCaseInsensitiveContains(self.searchTo)
            }
            
            if !self.searchFrom.isEmpty {
                self.fromSuggestions = busStopResults + locationResults
            }
            if !self.searchTo.isEmpty {
                self.toSuggestions = busStopResults + locationResults
            }
        }
    }

    private func getCoordinates(for searchResult: MKLocalSearchCompletion, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: searchResult)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                completion(nil)
                return
            }
            completion(coordinate)
        }
    }
}

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let to = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return from.distance(from: to)
    }
}
