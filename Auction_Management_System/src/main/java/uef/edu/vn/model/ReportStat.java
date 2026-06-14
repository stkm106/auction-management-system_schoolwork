package uef.edu.vn.model;

public class ReportStat {

    private String label;
    private double value;
    private long count;

    public ReportStat() {
    }

    public ReportStat(String label, double value) {
        this.label = label;
        this.value = value;
    }

    public ReportStat(String label, long count) {
        this.label = label;
        this.count = count;
    }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
    public double getValue() { return value; }
    public void setValue(double value) { this.value = value; }
    public long getCount() { return count; }
    public void setCount(long count) { this.count = count; }
}
