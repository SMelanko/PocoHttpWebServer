
#pragma once

#include <Poco/Util/ServerApplication.h>

class HttpServer : public Poco::Util::ServerApplication
{
public:
    HttpServer() = default;

protected:
    void initialize(Poco::Util::Application& self);
    void uninitialize();
    void defineOptions(Poco::Util::OptionSet& options);
    void handleOption(const std::string& name, const std::string& value);
    void displayHelp();
    int main(const std::vector<std::string>&);

private:
    bool _helpRequested = false;
};
