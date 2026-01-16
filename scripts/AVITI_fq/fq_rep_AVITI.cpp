#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstring>
#include <zlib.h>

namespace fs = std::filesystem;

/* ---------- C++17 ends_with ---------- */
inline bool ends_with(const std::string& s, const std::string& suf) {
    return s.size() >= suf.size() &&
           s.compare(s.size() - suf.size(), suf.size(), suf) == 0;
}

/* ---------- gzip / plain reader ---------- */
class GzFileReader {
public:
    explicit GzFileReader(const std::string& filename) {
        if (ends_with(filename, ".gz")) {
            gz_ = gzopen(filename.c_str(), "rb");
            if (!gz_) throw std::runtime_error("Cannot open gz file");
            gzbuffer(gz_, 1 << 20); // 1MB buffer
            is_gz_ = true;
        } else {
            ifs_.open(filename);
            if (!ifs_) throw std::runtime_error("Cannot open file");
            is_gz_ = false;
        }
    }

    ~GzFileReader() {
        if (gz_) gzclose(gz_);
        if (ifs_.is_open()) ifs_.close();
    }

    bool getline(std::string& line) {
        if (is_gz_) return gz_getline(line);
        return static_cast<bool>(std::getline(ifs_, line));
    }

private:
    gzFile gz_ = nullptr;
    std::ifstream ifs_;
    bool is_gz_;

    bool gz_getline(std::string& line) {
        line.clear();
        char buf[65536];
        while (true) {
            char* ret = gzgets(gz_, buf, sizeof(buf));
            if (!ret) return !line.empty();
            size_t len = std::strlen(buf);
            if (len && buf[len - 1] == '\n') {
                line.append(buf, len - 1);
                return true;
            }
            line.append(buf, len);
        }
    }
};

/* ---------- fast read name edit ---------- */
inline std::string edit_read_name(const std::string& line) {
    size_t sp = line.find(' ');
    if (sp == std::string::npos) return line;

    if (sp + 5 < line.size() &&
        (line[sp + 1] == '1' || line[sp + 1] == '2') &&
        line.compare(sp + 2, 4, ":N:0") == 0) {

        return line.substr(0, sp) + "/" + line[sp + 1];
    }
    return line;
}

/* ---------- main ---------- */
int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <directory>\n";
        return 1;
    }

    fs::path dir = argv[1];

    for (const auto& entry : fs::directory_iterator(dir)) {
        fs::path path = entry.path();
        std::string fname = path.filename().string();

        if (!(ends_with(fname, ".fastq") || ends_with(fname, ".fastq.gz")))
            continue;

        std::cout << "Processing: " << fname << std::endl;

        std::string outname;
        if (ends_with(fname, ".fastq.gz")) {
            outname = fname.substr(0, fname.size() - 9) + "_r1.fastq";
        } else {
            outname = fname.substr(0, fname.size() - 6) + "_r1.fastq";
        }

        fs::path outpath = path.parent_path() / outname;

        GzFileReader reader(path.string());
        std::ofstream out(outpath);

        std::string l1, l2, l3, l4;
        while (reader.getline(l1)) {
            reader.getline(l2);
            reader.getline(l3);
            reader.getline(l4);

            l1 = edit_read_name(l1);

            out << l1 << '\n'
                << l2 << '\n'
                << l3 << '\n'
                << l4 << '\n';
        }
    }
    return 0;
}

