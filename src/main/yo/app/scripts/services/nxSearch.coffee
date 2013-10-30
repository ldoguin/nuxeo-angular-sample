angular.module('nuxeoAngularSampleApp')

.factory "nxSearch", ["$http","$q",($http,$q)->
  
  nxSearch = {}
  nxSearch.items = []
  nxSearch.busy = false
  nxSearch.isNextPageAvailable = true
  nxSearch.currentPageIndex = 0
  nxSearch.pageSize = 20
  nxSearch.query = undefined
  nxSearch.bo = undefined

  nxSearch.setBOAdapter = (bo)->
    nxSearch.bo = bo

  nxSearch.setPageSize = (pageSize)->
    nxSearch.pageSize = pageSize

  nxSearch.setQuery = (query)->
    nxSearch.query = query

  nxSearch.nextPage = ()->
    if !nxSearch.query?
      $q.reject("You need to set a query")
      return

    if !nxSearch.isNextPageAvailable
      return

    if nxSearch.busy
      return

    nxSearch.busy = true

    url = "http://localhost:9000/nuxeo/api/v1/path/@search"
    if nxSearch.bo? then url += "/@bo/" + nxSearch.bo
    url += "?currentPageIndex="+nxSearch.currentPageIndex+"&pageSize="+nxSearch.pageSize+"&query=" + nxSearch.query;
    $http.get(url).then (response) -> 
      docs = response.data
      if(angular.isArray(docs.entries))
        nxSearch.currentPageIndex = docs.currentPageIndex + 1
        nxSearch.isNextPageAvailable = docs.isNextPageAvailable
        nxSearch.items.push doc for doc in docs.entries
        nxSearch.busy = false
      else
        nxSearch.busy = false
        $q.reject("just because")


  nxSearch
]