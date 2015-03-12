# According to RFC-7230, for HTTP response status we use "status reason"
# instead of status text or status message.

global.web = {}
web.request = (options) ->
    method = options.method
    url = options.url
    headers = options.headers ? null
    body = options.body ? null
    timeout = options.timeout ? null
    responseBodyType = options.responseBodyType ? "text"
    new Promise((resolve, reject) ->
        if mate.environmentType == "browser" then do ->
            xhr = new XMLHttpRequest()
            xhr.open(method, url)
            if headers?
                Object.forKeyValue(headers, (key, value) -> xhr.setRequestHeader(key, value))
            xhr.responseType =
                if responseBodyType == "binary"
                    "arraybuffer"
                else if responseBodyType == "text"
                    "text"
                else if responseBodyType == "json"
                    "text"
                else
                    fail()
            xhr.timeout = timeout ? 0
            xhr.onload = ->
                response =
                    statusCode: xhr.status
                    statusReason: xhr.statusText
                    headers:
                        xhr.getAllResponseHeaders()
                        .stripTrailingNewline()
                        .splitDeep("\r\n", ": ", 1)
                        .map((header) -> [header[0].toLowerCase(), header[1]])
                        .toObject()
                    body:
                        if responseBodyType == "binary"
                            new Uint8Array(xhr.response)
                        else if responseBodyType == "text"
                            xhr.response
                        else if responseBodyType == "json"
                            JSON.parse(xhr.response)
                        else
                            fail()
                if (200 <= response.statusCode < 300)
                    resolve(response)
                else
                    reject(response)
            xhr.onerror = ->
                reject(new Error("error"))
            xhr.ontimeout = ->
                reject(new Error("timeout"))
            xhr.send(body)
        else do ->
            http = module.require("http")
            https = module.require("https")
            urlMod = module.require("url")
            parsedUrl = urlMod.parse(url)
            httpOrHttps = if parsedUrl.protocol == "https:" then https else http
            rawRequest = httpOrHttps.request(
                {
                    method: method
                    hostname: parsedUrl.hostname
                    port: parsedUrl.port
                    path: parsedUrl.path
                    headers: headers
                },
                (rawResponse) ->
                    data = new Buffer(0)
                    rawResponse.on("data", (chunk) ->
                        data = Buffer.concat([data, chunk])
                    )
                    rawResponse.on("end", ->
                        response =
                            statusCode: rawResponse.statusCode
                            statusReason: rawResponse.statusMessage
                            headers: rawResponse.headers
                            body:
                                if responseBodyType == "binary"
                                    new Uint8Array(data)
                                else if responseBodyType == "text"
                                    data.toString()
                                else if responseBodyType == "json"
                                    JSON.parse(data.toString())
                                else
                                    fail()
                        if (200 <= response.statusCode < 300)
                            resolve(response)
                        else
                            reject(response)
                    )
            )
            if timeout?
                rawRequest.setTimeout(timeout, ->
                    rawRequest.abort()
                    reject(new Error("timeout"))
                )
            rawRequest.on("error", (e) ->
                reject(new Error("error"))
            ).end()
    )
web.get = (url, options) ->
    actualOptions =
        method: "GET"
        url: url
    Object.assign(actualOptions, options)
    web.request(actualOptions)
web.jsonGet = (url, options) ->
    actualOptions =
        method: "GET"
        url: url
        responseBodyType: "json"
    Object.assign(actualOptions, options)
    web.request(actualOptions)
web.post = (url, body, options) ->
    actualOptions =
        method: "POST"
        url: url
        body: body
    Object.assign(actualOptions, options)
    web.request(actualOptions)
web.jsonPost = (url, body, options) ->
    actualOptions =
        method: "POST"
        url: url
        headers: {"Content-Type": "application/json"}
        body: JSON.stringify(body)
        responseBodyType: "json"
    Object.assign(actualOptions, options)
    web.request(actualOptions)
