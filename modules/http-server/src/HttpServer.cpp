#include "HttpServer.h"
#include "RequestRouter.h"

#include <iostream>

#include <Poco/Net/HTTPServer.h>
#include <Poco/Net/HTTPServerParams.h>
#include <Poco/Net/ServerSocket.h>
#include <Poco/ThreadPool.h>
#include <Poco/Util/HelpFormatter.h>

void HttpServer::initialize(Poco::Util::Application& self)
{
    // Load default configuration files, if present.
    loadConfiguration();
    Poco::Util::ServerApplication::initialize(self);
}

void HttpServer::uninitialize()
{
    Poco::Util::ServerApplication::uninitialize();
}

void HttpServer::defineOptions(Poco::Util::OptionSet& options)
{
    Poco::Util::ServerApplication::defineOptions(options);

    options.addOption(
        Poco::Util::Option("help", "h", "display help information on command line arguments")
            .required(false)
            .repeatable(false));
}

void HttpServer::handleOption(const std::string& name, const std::string& value)
{
    Poco::Util::ServerApplication::handleOption(name, value);

    if (name == "help") {
        _helpRequested = true;
    }
}

void HttpServer::displayHelp()
{
    Poco::Util::HelpFormatter helpFormatter(options());
    helpFormatter.setCommand(commandName());
    helpFormatter.setUsage("OPTIONS");
    helpFormatter.setHeader("A web server that serves the current date and time.");
    helpFormatter.format(std::cout);
}

int HttpServer::main(const std::vector<std::string>&)
{
    if (_helpRequested) {
        displayHelp();
    } else {
        // Get parameters from configuration file.
        unsigned short port =
            static_cast<unsigned short>(config().getInt("HTTPTimeServer.port", 80));
        int maxQueued = config().getInt("HTTPTimeServer.maxQueued", 100);
        int maxThreads = config().getInt("HTTPTimeServer.maxThreads", 16);
        Poco::ThreadPool::defaultPool().addCapacity(maxThreads);

        auto pParams = new Poco::Net::HTTPServerParams;
        pParams->setMaxQueued(maxQueued);
        pParams->setMaxThreads(maxThreads);

        // set-up a server socket
        Poco::Net::ServerSocket svs(port);
        // set-up a HTTPServer instance
        Poco::Net::HTTPServer srv(new RequestRouter{}, svs, pParams);
        // start the HTTPServer
        srv.start();
        // wait for CTRL-C or kill
        waitForTerminationRequest();
        // Stop the HTTPServer
        srv.stop();
    }

    return Application::EXIT_OK;
}
