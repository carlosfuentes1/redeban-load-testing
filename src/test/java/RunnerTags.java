import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import static org.junit.jupiter.api.Assertions.*;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

class RunnerTags {

    @Test
    void testParallel() {
       //Results results = Runner.path("classpath:CORRandADQUI/aprobadaOkKKKKKK.feature")
        //Results results = Runner.path("classpath:CORRandADQUI/TransaccionalADQUI.feature")

       Results results = Runner.path("classpath:Cierres/Cierre_VoucherQA.feature")
                .outputCucumberJson(true)
                .tags("~@ignore")
                //.karateEnv("dev-adqui")
                .karateEnv("dev-corr")
                .parallel(4);
        generateReport(results.getReportDir());
        assertTrue(results.getFailCount() == 0, results.getErrorMessages());
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("build"), "transacciones");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}
