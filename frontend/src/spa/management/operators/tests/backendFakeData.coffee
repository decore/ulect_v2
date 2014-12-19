###
backendFake - test back-end data for tests or debug UI
# https://docs.angularjs.org/api/ngMockE2E/service/$httpBackend
###
define [
    'cs!backendFake/index' ##NOTE: must used module contain 'ngMock'

], (module)->
    module.run ['$httpBackend', 'baseUrl', ($httpBackend, baseUrl)->
        ###
        #NOTE: fake demo data
        ###
        fakeDataArr = [
            {
            userId: 1,
            userName: "user1-",
            email: "e1",
            role: "admin",
            timeZoneOffset: 600
            },
            {
            userId: 2,
            userName: "user2",
            email: "e2",
            role: "admin",
            timeZoneOffset: -600
            },
            {
            userId: 3,
            userName: "user3",
            email: "e3",
            role: "admin",
            timeZoneOffset: 300
            },
            {
            userId: 4,
            userName: "user4",
            email: "e4",
            role: "admin",
            timeZoneOffset: -210
            }
        ]
        ###
        when(method, url, [data], [headers])
        Creates a new backend definition.
        ###
        ###
        whenGET(url, [headers])
        Creates a new backend definition for GET requests.
        ###
        $httpBackend.whenGET(baseUrl + '/users?count=10&page=1&sort=%2BuserName').respond(->
            [200, fakeDataArr, {}])
        ###
        whenDELETE(url, [headers])
        Creates a new backend definition for DELETE requests.
        ###
        $httpBackend.whenDELETE(baseUrl + '/test/1').respond(->
            [201, {}, {}])
        ###
        whenPOST(url, [data], [headers])
        Creates a new backend definition for POST requests.
        ###
        $httpBackend.whenPOST(baseUrl + '/test').respond(
            (method, url, data)->
                newData = angular.fromJson(data)
                fakeDataArr.push(newData)
                return [200, fakeDataArr, {'X-Prism-Total-Items-Count': fakeDataArr.length}]
        )
        ###
        whenPUT(url, [data], [headers])
        Creates a new backend definition for PUT requests
        ###
        $httpBackend.whenPUT(baseUrl + '/tasks/1').respond(
            (method, url, data)->
                return [200, data, {}]
        )
    ]