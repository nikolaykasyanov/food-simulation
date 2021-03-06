import jason.environment.grid.GridWorldView;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.*;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartFrame;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.xy.DefaultXYDataset;

    
/** class that implements the View of the Game of Life application */
public class FoodView extends GridWorldView {

    private static final long serialVersionUID = 1L;

    FoodModel hmodel;
	FoodEnvironment henv;

    DefaultXYDataset dataset = new DefaultXYDataset();
	
    public FoodView(FoodModel model, final FoodEnvironment env) {
        super(model, "Normative Simulation", 700);
		hmodel = model;
		henv = env;
        setVisible(true);
        repaint();
		
        getCanvas().addMouseListener(new MouseListener() {
            public void mouseClicked(MouseEvent e) {
                int col = e.getX() / cellSizeW;
                int lin = e.getY() / cellSizeH;
                if (col >= 0 && lin >= 0 && col < getModel().getWidth() && lin < getModel().getHeight()) {
                    hmodel.add(FoodModel.FOOD, col, lin);
					//env.updateNeighbors(hmodel.getAgId(col,lin));
                    update(col, lin);
                }
            }
            public void mouseExited(MouseEvent e) {}
            public void mouseEntered(MouseEvent e) {}
            public void mousePressed(MouseEvent e) {}
            public void mouseReleased(MouseEvent e) {}
        });
        
        JFreeChart xyc = ChartFactory.createXYLineChart( 
                "Agents' strength",
                "step",
                "strength",
                dataset, // dataset, 
                PlotOrientation.VERTICAL, // orientation, 
                true, // legend, 
                true, // tooltips, 
                true); //urls
        ChartFrame frame = new ChartFrame("Normative Simulation: Agents' Strength", xyc); 
        frame.pack(); 
        frame.setVisible(true);
    }
    
    public void addSerie(String key, double[][] values) {
        dataset.addSeries(key, values);
    }

    @Override
    public void drawAgent(Graphics g, int x, int y, Color c, int id) {
		String agentName = henv.id2ag.get(id);
		assert agentName != null : "Can't get agent name for id " + id;
		if (agentName != null && agentName.startsWith("forager")) {
			g.setColor(Color.RED);
		}
		else {
			g.setColor(Color.GRAY);
		}
        g.fillRect(x * cellSizeW + 1, y * cellSizeH+1, cellSizeW-1, cellSizeH-1);
        if (hmodel.hasObject(FoodModel.FOOD, x, y)) {
	        drawFood(g, x, y);			
        }
		if (hmodel.hasObject(FoodModel.QUEEN, x, y)) {
			drawQueen(g, x, y);
		}
		if (hmodel.hasObject(FoodModel.FOOD_STORAGE, x, y)) {
			drawStorage(g, x, y);
		}
		if (hmodel.hasObject(FoodModel.QUEENS_FOOD, x, y)) {
			drawStoredFood(g, x, y);
		}
		if (hmodel.hasObject(FoodModel.RESERVED, x, y)) {
			drawReserved(g, x, y);
		}
    }
	
	@Override
	public void draw(Graphics g, int x, int y, int object) {
		if (object == FoodModel.FOOD && !hmodel.hasObject(FoodModel.AGENT, x, y)) {
	        drawFood(g, x, y);			
		}
		if (object == FoodModel.QUEEN && !hmodel.hasObject(FoodModel.AGENT, x, y)) {
			drawQueen(g, x, y);
		}
		if (object == FoodModel.FOOD_STORAGE && !hmodel.hasObject(FoodModel.AGENT, x, y)) {
			drawStorage(g, x, y);	
		}
		if (object == FoodModel.QUEENS_FOOD && !hmodel.hasObject(FoodModel.AGENT, x, y)) {
			drawStoredFood(g, x, y);
		}
		if (object == FoodModel.RESERVED && !hmodel.hasObject(FoodModel.AGENT, x, y)) {
			drawReserved(g, x, y);
		}
	}

	public void drawFood(Graphics g, int x, int y) {
		g.setColor(Color.YELLOW);
		g.fillRect(x * cellSizeW + 2, y * cellSizeH+2, cellSizeW-4, cellSizeH-4);			
	}
	
	public void drawQueen(Graphics g, int x, int y) {
		g.setColor(Color.CYAN);
		g.fillRect(x * cellSizeW + 2, y * cellSizeH+2, cellSizeW-4, cellSizeH-4);
	}
	
	public void drawStorage(Graphics g, int x, int y) {
		g.setColor(Color.MAGENTA);
		g.fillRect(x * cellSizeW + 4, y * cellSizeH+4, cellSizeW-8, cellSizeH-8);
	}
	
	public void drawStoredFood(Graphics g, int x, int y) {
		g.setColor(Color.GREEN);
		g.fillRect(x * cellSizeW + 3, y * cellSizeH+3, cellSizeW-6, cellSizeH-6);
	}
	
	public void drawReserved(Graphics g, int x, int y) {
		g.setColor(Color.ORANGE);
		g.fillRect(x * cellSizeW, y * cellSizeH, cellSizeW, cellSizeH);
	}

}
